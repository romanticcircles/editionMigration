<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">
    
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="corresp">
        <corresp>
                <xsl:for-each select="./to/name">
                    <xsl:sort/>
                        <name id="{@id}"><xsl:apply-templates/></name>
                        <xsl:apply-templates select="following-sibling::letter"/>
                </xsl:for-each>
        </corresp>
    </xsl:template>

</xsl:stylesheet>
