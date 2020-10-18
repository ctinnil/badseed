#!/usr/bin/env bash
#Thanks to @pbell https://stackoverflow.com/questions/56517403/how-to-create-and-manage-macos-safari-bookmarks-programmatically

declare -r plist_path=~/Library/Safari/Bookmarks.plist

# ANSI/VT100 Control sequences for colored error log.
declare -r fmt_red='\x1b[31m'
declare -r fmt_norm='\x1b[0m'
declare -r fmt_green='\x1b[32m'
declare -r fmt_bg_black='\x1b[40m'

declare -r error_badge="${fmt_red}${fmt_bg_black}ERR!${fmt_norm}"
declare -r tick_symbol="${fmt_green}\\xE2\\x9C\\x94${fmt_norm}"

if [ -z "$1" ] || [ -z "$2" ]; then
  echo -e "${error_badge} Missing required arguments" >&2
  exit 1
fi

bkmarks_folder_name=$1
bkmarks_spec=$2

keep_existing_bkmarks=${3:-false}

# Transform bookmark spec string into array using comma `,` as delimiter.
IFS=',' read -r -a bkmarks_spec <<< "${bkmarks_spec//, /,}"

# Append UUID/GUID to each bookmark spec element.
bkmarks_spec_with_uuid=()
while read -rd ''; do
  [[ $REPLY ]] && bkmarks_spec_with_uuid+=("${REPLY} $(uuidgen)")
done < <(printf '%s\0' "${bkmarks_spec[@]}")

# Transform bookmark spec array back to string using comma `,` as delimiter.
bkmarks_spec_str=$(printf '%s,' "${bkmarks_spec_with_uuid[@]}")
bkmarks_spec_str=${bkmarks_spec_str%,} # Omit trailing comma character.

# Check the .plist file exists.
if [ ! -f "$plist_path" ]; then
  echo -e "${error_badge} File not found: ${plist_path}" >&2
  exit 1
fi

# Verify that plist exists and contains no syntax errors.
if ! plutil -lint -s "$plist_path" >/dev/null; then
  echo -e "${error_badge} Broken or missing plist: ${plist_path}" >&2
  exit 1
fi

# Ignore ShellCheck errors regarding XSLT variable references in template below.
# shellcheck disable=SC2154
xslt() {
cat <<'EOX'
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:strip-space elements="*"/>
  <xsl:output
    method="xml"
    indent="yes"
    doctype-system="http://www.apple.com/DTDs/PropertyList-1.0.dtd"
    doctype-public="-//Apple//DTD PLIST 1.0//EN"/>

  <xsl:param name="bkmarks-folder"/>
  <xsl:param name="bkmarks"/>
  <xsl:param name="guid"/>
  <xsl:param name="keep-existing" select="false" />

  <xsl:variable name="bmCount">
    <xsl:value-of select="string-length($bkmarks) -
          string-length(translate($bkmarks, ',', '')) + 1"/>
  </xsl:variable>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template name="getNthValue">
    <xsl:param name="list"/>
    <xsl:param name="n"/>
    <xsl:param name="delimiter"/>

    <xsl:choose>
      <xsl:when test="$n = 1">
        <xsl:value-of select=
              "substring-before(concat($list, $delimiter), $delimiter)"/>
      </xsl:when>
      <xsl:when test="contains($list, $delimiter) and $n > 1">
        <!-- recursive call -->
        <xsl:call-template name="getNthValue">
          <xsl:with-param name="list"
              select="substring-after($list, $delimiter)"/>
          <xsl:with-param name="n" select="$n - 1"/>
          <xsl:with-param name="delimiter" select="$delimiter"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="createBmEntryFragment">
    <xsl:param name="loopCount" select="1"/>

    <xsl:variable name="bmInfo">
      <xsl:call-template name="getNthValue">
        <xsl:with-param name="list" select="$bkmarks"/>
        <xsl:with-param name="delimiter" select="','"/>
        <xsl:with-param name="n" select="$loopCount"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="bmkName">
      <xsl:call-template name="getNthValue">
        <xsl:with-param name="list" select="$bmInfo"/>
        <xsl:with-param name="delimiter" select="' '"/>
        <xsl:with-param name="n" select="1"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="bmURL">
      <xsl:call-template name="getNthValue">
        <xsl:with-param name="list" select="$bmInfo"/>
        <xsl:with-param name="delimiter" select="' '"/>
        <xsl:with-param name="n" select="2"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="bmGUID">
      <xsl:call-template name="getNthValue">
        <xsl:with-param name="list" select="$bmInfo"/>
        <xsl:with-param name="delimiter" select="' '"/>
        <xsl:with-param name="n" select="3"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$loopCount > 0">
      <dict>
        <key>ReadingListNonSync</key>
        <dict>
          <key>neverFetchMetadata</key>
          <false/>
        </dict>
        <key>URIDictionary</key>
        <dict>
          <key>title</key>
          <string>
            <xsl:value-of select="$bmkName"/>
          </string>
        </dict>
        <key>URLString</key>
        <string>
          <xsl:value-of select="$bmURL"/>
        </string>
        <key>WebBookmarkType</key>
        <string>WebBookmarkTypeLeaf</string>
        <key>WebBookmarkUUID</key>
        <string>
          <xsl:value-of select="$bmGUID"/>
        </string>
      </dict>
      <!-- recursive call -->
      <xsl:call-template name="createBmEntryFragment">
        <xsl:with-param name="loopCount" select="$loopCount - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="createBmFolderFragment">
    <dict>
      <key>Children</key>
      <array>
        <xsl:call-template name="createBmEntryFragment">
          <xsl:with-param name="loopCount" select="$bmCount"/>
        </xsl:call-template>
        <xsl:if test="$keep-existing = 'true'">
          <xsl:copy-of select="./array/node()|@*"/>
        </xsl:if>
      </array>
      <key>Title</key>
      <string>
        <xsl:value-of select="$bkmarks-folder"/>
      </string>
      <key>WebBookmarkType</key>
      <string>WebBookmarkTypeList</string>
      <key>WebBookmarkUUID</key>
      <string>
        <xsl:value-of select="$guid"/>
      </string>
    </dict>
  </xsl:template>

  <xsl:template match="dict[string[text()='BookmarksBar']]/array">
    <array>
      <xsl:for-each select="dict">
        <xsl:choose>
          <xsl:when test="string[text()=$bkmarks-folder]">
            <xsl:call-template name="createBmFolderFragment"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:apply-templates select="@*|node()" />
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <xsl:if test="not(./dict/string[text()=$bkmarks-folder])">
        <xsl:call-template name="createBmFolderFragment"/>
      </xsl:if>
    </array>
  </xsl:template>

</xsl:stylesheet>
EOX
}

# Convert the .plist to XML format
plutil -convert xml1 -- "$plist_path" >/dev/null || {
  echo -e "${error_badge} Cannot convert .plist to xml format" >&2
  exit 1
}

# Generate a UUID/GUID for the folder.
folder_guid=$(uuidgen)

xsltproc --novalid \
    --stringparam keep-existing "$keep_existing_bkmarks" \
    --stringparam bkmarks-folder "$bkmarks_folder_name" \
    --stringparam bkmarks "$bkmarks_spec_str" \
    --stringparam guid "$folder_guid" \
    <(xslt) - <"$plist_path" > "${TMPDIR}result-plist.xml"

# Convert the .plist to binary format
plutil -convert binary1 -- "${TMPDIR}result-plist.xml" >/dev/null || {
  echo -e "${error_badge} Cannot convert .plist to binary format" >&2
  exit 1
}

mv -- "${TMPDIR}result-plist.xml" "$plist_path" 2>/dev/null || {
  echo -e "${error_badge} Cannot move .plist from TMPDIR to ${plist_path}" >&2
  exit 1
}

echo -e "${tick_symbol} Successfully created Safari bookmarks."
