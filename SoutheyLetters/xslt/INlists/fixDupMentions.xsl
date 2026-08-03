<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
        
        <!-- Identity transform: Copy everything as-is by default -->
        <xsl:template match="@* | node()">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
        </xsl:template>
        
        <!-- Group duplicate letter nodes inside <mentioned> -->
        <xsl:template match="mentioned">
            <xsl:copy>
                <!-- Copy attributes and non-letter children (like <name>) -->
                <xsl:apply-templates select="@* | node()[not(self::letter)]"/>
                
                <!-- Group <letter> tags by their id attribute -->
                <xsl:for-each-group select="letter" group-by="@id">
                    <letter id="{@id}">
                        <!-- Output the original text content -->
                        <xsl:value-of select="current-group()[1]"/>
                        
                        <!-- If mentioned more than once, append the mention count -->
                        <xsl:if test="count(current-group()) &gt; 1">
                            <xsl:value-of select="concat(' (', count(current-group()), ' mentions)')"/>
                        </xsl:if>
                    </letter>
                </xsl:for-each-group>
            </xsl:copy>
        </xsl:template>
        
    </xsl:stylesheet>