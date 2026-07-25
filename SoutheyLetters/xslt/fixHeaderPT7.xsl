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
            <xsl:result-document href="new/{@code}">
            <xsl:apply-templates select="document(@code)/tei:TEI"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:sourceDesc/tei:p[starts-with(., 'For permission to publish')]">
                <p xmlns="http://www.tei-c.org/ns/1.0">These letters were edited by Lynda Pratt and Ian Packer.</p>
                <p xmlns="http://www.tei-c.org/ns/1.0">Every effort has been made to contact
                    copyright holders for their permission to reprint material in this edition. The
                    editors would be grateful to hear from any copyright holder who is not here
                    acknowledged and undertake to rectify any omissions or errors in future updates
                    of this
                    edition.</p>
                <p  xmlns="http://www.tei-c.org/ns/1.0">The editors thank the following for giving us access to manuscripts in their
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
    </xsl:template>
    
    <xsl:template match="tei:category[@xml:id='Q37068']">
        <category xmlns="http://www.tei-c.org/ns/1.0" xml:id="Q216838">
            <catDesc>Robert Southey</catDesc>
        </category>
        <category xmlns="http://www.tei-c.org/ns/1.0" xml:id="Q5977111">
            <catDesc>Romantic literature</catDesc>
        </category>
    </xsl:template>
    
    <xsl:template match="tei:catRef[@target='#Q1277575']">
        <catRef xmlns="http://www.tei-c.org/ns/1.0" target="#Q216838" scheme="Wikidata"/>
        <catRef xmlns="http://www.tei-c.org/ns/1.0" target="#Q5977111" scheme="Wikidata"/>
        <catRef xmlns="http://www.tei-c.org/ns/1.0" target="#Q1277575" scheme="Wikidata"/>
    </xsl:template>
    
</xsl:stylesheet>
