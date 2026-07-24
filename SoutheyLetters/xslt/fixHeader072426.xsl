<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="2.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:for-each select="item">
            <xsl:apply-templates select="document(@code)/tei:TEI">
                <xsl:with-param name="fileName" select="@code"/>
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:param name="fileName"/>
        <xsl:result-document href="new/{$fileName}">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="tei:sourceDesc/tei:p">
        <xsl:choose>
            <xsl:when test="starts-with(., 'For permission to publish')">
                <p xmlns="http://www.tei-c.org/ns/1.0">Every effort has been made to contact
                    copyright holders for their permission to reprint material in this edition. The
                    editors would be grateful to hear from any copyright holder who is not here
                    acknowledged and undertake to rectify any omissions or errors in future updates
                    of this
                    edition.<xsl:text disable-output-escaping="yes">&lt;/p&gt;&lt;p&gt;</xsl:text>The
                    editors thank the following for giving us access to manuscripts in their
                    collections: the Beinecke Rare Books and Manuscript Library, Yale University;
                    Berg Collection of English and American Literature, The New York Public Library,
                    Astor, Lenox and Tilden Foundations; the Bodleian Library Oxford University; the
                    British Library; Boston Public Library; the Syndics of Cambridge University
                    Library; the Syndics of the Fitzwilliam Museum Cambridge; Haverford College,
                    Connecticut; the Historical Society of Pennsylvania; the Hornby Library,
                    Liverpool Libraries and Information Services; the Houghton Library, Harvard
                    University; the John Rylands Library, Manchester; the Kenneth Spencer Research
                    Library, University of Kansas; Luton Museum (Bedfordshire County Council);
                    Massachusetts Historical Society; McGill University Library; the National
                    Library of Scotland; the Newberry Library, Chicago; the New York Public Library
                    (Pforzheimer Collections); the Pierpont Morgan Library, New York; the Public
                    Record Offices of Bedford, Suffolk (Bury St Edmunds) and Northumberland, the
                    Master and Fellows of Trinity College, Cambridge; the Society of Antiquaries of
                    Newcastle upon Tyne; the Trustees of the William Salt Library, Stafford, the
                    Wisbech and Fenland Museum; the University of Virginia Library.</p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
