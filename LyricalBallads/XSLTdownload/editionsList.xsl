<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="3.0">
        <xsl:output method="xhtml" omit-xml-declaration="no" encoding="UTF-8"/>
        <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
            <xsl:comment>This XHTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
            <head><xsl:apply-templates select="tei:teiHeader"/></head>
            <body><xsl:apply-templates select="tei:text"></xsl:apply-templates></body>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <title><xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title"/></title>
        <style>
            body { margin: 2rem; }
            table {
            margin-top: 1rem;
            border-collapse: collapse;
            }
            th, td {
            border: 1px solid black;
            padding: 10px;
            text-align: left;
            vertical-align: top;
            }
            .id { width: 100px; min-width: 100px; }
            .short { width: 250px; min-width: 250px; }
            .long { width: 450px; min-width: 450px; }
            .back {
            position: fixed;
            top: 20px;
            left: 20px;
            }
            a {
            color: #3f6345;
            text-decoration: underline;
            font-weight: bold;
            }
            a:hover {
            color: #5f9468;
            }
        </style>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <div style="margin-left: 5rem; position: relative;">
            <h2>Editions List</h2>
            <p class="back"><a href="index.html"><img src="header/LBvols.png" height="36" width="36" alt="link back"/></a></p>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <table>
            <tr>
                <th class="id">File Name</th>
                <th class="short">Short Description</th>
                <th class="long">Longer Description</th>
            </tr>
            <xsl:apply-templates select="tei:label"/>
        </table>
    </xsl:template>
    
    <xsl:template match="tei:label">
        <tr>
            <td class="id"><a href="HTML/{@xml:id}.html" target="_blank"><xsl:value-of select="@xml:id"/></a></td>
        <td class="short"><xsl:apply-templates/></td>
            <td class="long"><xsl:apply-templates select="following-sibling::tei:item[1]"/></td>
        </tr>
    </xsl:template>
    
   
</xsl:stylesheet>