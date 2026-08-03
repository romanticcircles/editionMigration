<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
        
        <xsl:output method="xml" indent="yes"/>
        <xsl:mode on-no-match="shallow-copy"/>
        
        <!-- Match the root element -->
        <xsl:template match="mentions">
            <xsl:copy>
                <!-- Group all <name> elements by their text content -->
                <xsl:for-each-group select="name" group-by="normalize-space(.)">
                    <xsl:sort select="."/>
                    <mentioned>
                        <!-- Output the unique name -->
                        <xsl:copy-of select="."/>
                        
                        <!-- Get all <letter> elements associated with this grouped name -->
                        <xsl:for-each select="current-group()">
                            <xsl:copy-of select="following-sibling::*[1][self::letter]"/>
                        </xsl:for-each>
                    </mentioned>
                </xsl:for-each-group>
            </xsl:copy>
        </xsl:template>
        
    </xsl:stylesheet>