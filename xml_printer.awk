#!/usr/bin/awk -f

BEGIN {
XML_STRING="<layoutList>\n\
  <layout>\n\
    <configItem>\n\
      <name>"LAYOUT"</name>\n\
      <shortDescription>"ABBR"</shortDescription>\n\
      <description>"NAME"</description>\n\
      <countryList>	\n\
        <iso3166Id></iso3166Id>\n\
      </countryList>\n\
      <languageList>\n\
        <iso639Id>dan</iso639Id>\n\
      </languageList>\n\
    </configItem>\n\
    <variantList>\n\
      <variant>\n\
        <configItem>\n\
          <name>"NAME"</name>\n\
          <description>Insert Description</description>\n\
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
