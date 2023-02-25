#!/usr/bin/awk -f

BEGIN {
XML_STRING="<layout>\n\
    <configItem>\n\
      <name>"LAYOUT"</name>\n\
      <shortDescription>"ABBR"</shortDescription>\n\
      <description>"NAME"</description>\n\
    </configItem>\n\
    <variantList>\n\
      <variant>\n\
        <configItem>\n\
          <name>"NAME"</name>\n\
          <description>"DESC"</description>\n\
        </configItem>\n\
      </variant>\n\
    </variantList>\n\
  </layout>"
}

{
    print $0
}

/<layoutList>/{
    print XML_STRING
}  
