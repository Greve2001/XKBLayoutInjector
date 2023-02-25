#!/usr/bin/awk -f

BEGIN {
xml_string="<layout>\n\
    <configItem>\n\
      <name>"layout"</name>\n\
      <shortDescription>"abbr"</shortDescription>\n\
      <description>"name"</description>\n\
    </configItem>\n\
    <variantList>\n\
      <variant>\n\
        <configItem>\n\
          <name>"name"</name>\n\
          <description>"desc"</description>\n\
        </configItem>\n\
      </variant>\n\
    </variantList>\n\
  </layout>"
}

{
    print $0
}

/<layoutList>/{
    print xml_string
}  
