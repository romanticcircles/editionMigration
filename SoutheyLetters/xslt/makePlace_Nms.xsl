<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="3.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:TEI">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:text">
        <xsl:apply-templates select="tei:body/tei:div/tei:listPlace"/>
    </xsl:template>

    <xsl:template match="tei:listPlace">
        <names>
        <xsl:for-each select="tei:place">
                <xsl:apply-templates select="tei:placeName"/>
        </xsl:for-each>
        </names>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <place xml:id="{@xml:id}">
            <xsl:value-of select="."/>
        </place>
    </xsl:template>


</xsl:stylesheet>
