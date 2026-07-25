<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- this identity template copies the whole xml document exactly as it is -->
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- to make changes to the xml, match the node/tag in the original document that you wish to change
        and then inside that template, add the tag and its attributes that you wish to use instead, as here: -->
    
    <xsl:template match="tei:persName">
        <xsl:choose>
            <xsl:when test="contains(substring-after(., ','), ',')">
                <persName xmlns="http://www.tei-c.org/ns/1.0" xml:id="{@xml:id}">
                    <roleName xmlns="http://www.tei-c.org/ns/1.0"><xsl:value-of select="normalize-space(substring-before(substring-after(substring-after(., ','), ','), '('))"/></roleName>
                    <forename><xsl:value-of select="normalize-space(substring-before(substring-after(., ','), ','))"/></forename>
                    <surname>
                        <xsl:if test="@type">
                            <xsl:attribute name="type" select="@type"/>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(substring-before(., ','))"/>
                    </surname>
                </persName>
            </xsl:when>
            <xsl:otherwise>
                <persName xmlns="http://www.tei-c.org/ns/1.0" xml:id="{@xml:id}">
                <forename><xsl:value-of select="normalize-space(substring-before(substring-after(., ','), '('))"/></forename>
                <surname>
                    <xsl:if test="@type">
                        <xsl:attribute name="type" select="@type"/>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(substring-before(., ','))"/>
                </surname>
                </persName>
            </xsl:otherwise>
        </xsl:choose>
        <birth xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:value-of select="substring-after(substring-before(., '–'), '(')"/>
        </birth>
        <death xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:choose>
                <xsl:when test="contains(., '(d.')">
                    <xsl:attribute name="when">
                        <xsl:value-of select="normalize-space(substring-before(substring-after(., '(d.'), ')'))"/>
                    </xsl:attribute>
                    <xsl:value-of select="substring-before(substring-after(., '('), ')')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(substring-after(., '–'), ')')"/>
                </xsl:otherwise>
            </xsl:choose>
        </death>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <xsl:choose>
            <xsl:when test="contains(., 'DNB')">
                <title xmlns="http://www.tei-c.org/ns/1.0" ref="#dnb">
                    <xsl:value-of select="."/>
                </title>
            </xsl:when>
            <xsl:when test="contains(., 'Hist P')">
                <title xmlns="http://www.tei-c.org/ns/1.0" ref="#hp">
                    <xsl:value-of select="."/>
                </title>
            </xsl:when>
            <xsl:otherwise>
                <title xmlns="http://www.tei-c.org/ns/1.0"><xsl:value-of select="."/></title>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>