<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="text" encoding="UTF-8" byte-order-mark="yes" omit-xml-declaration="yes" indent="no"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="mentions">
        <xsl:result-document href="../HTML/personsCSV/all.csv">
            <xsl:text>People Mentioned in the Collected Letters of Robert Southey&#13;</xsl:text>
        <xsl:for-each select="person">
            <xsl:value-of select="concat('&quot;', name, '&quot;')"/>
            <xsl:text>&#13;</xsl:text>
        </xsl:for-each>
        </xsl:result-document>
        <xsl:for-each select="person">
            <xsl:result-document href="../HTML/personsCSV/{name/@id}.csv">
                <xsl:value-of select="concat('&quot;', name, '&quot;')"/>
        <xsl:text>&#13;&#13;Mentioned In, URL&#13;</xsl:text>
            <xsl:apply-templates select="letter"/>
                <xsl:text>&#13;Letters To, URL&#13;</xsl:text>
            <xsl:call-template name="getTo">
                <xsl:with-param name="idNbr" select="name/@id"/>
            </xsl:call-template>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="letter">
        <xsl:variable name="baseURL" select="'https://cha.artsci.tamu.edu/SoutheyLetters/HTML/'"/>
        <xsl:variable name="getPath">
            <xsl:value-of select="substring-before(substring-after(@id, 'southey.'), '.')"/>
        </xsl:variable>
        <xsl:variable name="ptPath">
            <xsl:choose>
                <xsl:when test="$getPath = '1'">Part_One</xsl:when>
                <xsl:when test="$getPath = '2'">Part_Two</xsl:when>
                <xsl:when test="$getPath = '3'">Part_Three</xsl:when>
                <xsl:when test="$getPath = '4'">Part_Four</xsl:when>
                <xsl:when test="$getPath = '5'">Part_Five</xsl:when>
                <xsl:when test="$getPath = '6'">Part_Six</xsl:when>
                <xsl:when test="$getPath = '7'">Part_Seven</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="normalize-space(translate(., ',', ' '))"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="concat($baseURL, $ptPath, '/', @id, '.html')"/>
        <xsl:text>&#13;</xsl:text>
    </xsl:template>
    
    <xsl:template name="getTo">
        <xsl:param name="idNbr"/>
        <xsl:variable name="baseURL" select="'https://cha.artsci.tamu.edu/SoutheyLetters/HTML/'"/>
        <xsl:variable name="getPath">
            <xsl:value-of select="substring-before(substring-after(@id, 'southey.'), '.')"/>
        </xsl:variable>
        <xsl:variable name="ptPath">
            <xsl:choose>
                <xsl:when test="$getPath = '1'">Part_One</xsl:when>
                <xsl:when test="$getPath = '2'">Part_Two</xsl:when>
                <xsl:when test="$getPath = '3'">Part_Three</xsl:when>
                <xsl:when test="$getPath = '4'">Part_Four</xsl:when>
                <xsl:when test="$getPath = '5'">Part_Five</xsl:when>
                <xsl:when test="$getPath = '6'">Part_Six</xsl:when>
                <xsl:when test="$getPath = '7'">Part_Seven</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="document('TOall.xml')/corresp/to/name[@id = $idNbr]">
            <xsl:for-each select="following-sibling::letter">
                <xsl:value-of select="normalize-space(translate(., ',', ' '))"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat($baseURL, $ptPath, '/', @id, '.html')"/>
                <xsl:text>&#13;</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
        
    
</xsl:stylesheet>