<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs html tei" version="2.0">
    <xsl:output method="xhtml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>

    <!--Run on LBobjectsGrouped.xml in the main LyricalBallads folder. -->

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="LBobjects_grouped">
        <xsl:for-each select="group">
            <xsl:variable name="poemID" select="./@name"/>
            <xsl:variable name="poemName" select="./title"/>
            <xsl:result-document href="compare/{$poemID}.html">
                <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
                <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                        <title>
                            <xsl:value-of select="concat('Lyrical Ballads: ', $poemName)"/>
                        </title>
                        <meta name="viewport" content="width=device-width, initial-scale=1"/>
                        <link rel="stylesheet" href="../css/cfisonMain.css"/>
                        <link rel="preconnect" href="https://fonts.googleapis.com"/>
                        <link rel="preconnect" href="https://fonts.gstatic.com"
                            crossorigin="anonymous"/>
                        <link
                            href="https://fonts.googleapis.com/css2?family=Baskervville:ital,wght@0,400..700;1,400..700&amp;display=swap"
                            rel="stylesheet"/>
                    </head>
                    <body>
                        <img src="../header/lakeDistBanner.png" alt="banner" class="banner"/>
                        <a href="../index.html">
                            <img src="../header/LBvols.png" alt="site logo" class="logo"/>
                        </a>
                        <nav>
                            <ul id="navBar">
                                <li>
                                    <a href="../index.html">Home</a>
                                </li>
                                <li>
                                    <a href="../introduction.html">Introduction</a>
                                </li>
                                <li>
                                    <a href="../editions.html">Editions</a>
                                </li>
                                <li>
                                    <a href="../compare.html">Compare</a>
                                </li>
                                <li>
                                    <a href="../pageImages/index.html">Page Images</a>
                                </li>
                                <li>
                                    <a href="../about.html">About</a>
                                </li>
                            </ul>
                        </nav>
                        <xsl:apply-templates select="."/>
                        <div class="share-container">
                            <button id="syncToggleBtn" class="copy-btn">Sync Scrolling: On</button>
                            <span>&#160;</span>
                            <button id="copyLinkBtn" class="copy-btn">Copy Link to this
                                Comparison</button>
                            <span id="copyFeedback" class="copy-feedback">Link Copied!</span>
                        </div>
                        <script src="../js/compare.js"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="group">
        <xsl:variable name="noItems" select="count(item)"/>
        <div class="main-container" xmlns="http://www.w3.org/1999/xhtml">
            <h3 class="page-title">
                <xsl:value-of select="concat('Compare ', $noItems, ' versions :: ', title)"/>
            </h3>
            <xsl:if test="title = 'Preface'">
                <h5 style="margin-top: -0.5rem; margin-bottom: 0.5rem; text-align: center;">
                    <em>See the changes made for the 1802, third edition</em>
                    <a href="../comparePref/index.html">
                        <img src="../images/edIcon.png" alt="link to changes"
                            style="display: inline; height: 20px; width: 20px;"/>
                    </a>
                </h5>
            </xsl:if>
            <table class="frames">
                <tr>
                    <td>
                        <div class="dropdown-container">
                            <select id="dropdown1">
                                <option value="" data-description="">Select an edition...</option>
                                <xsl:apply-templates select="item"/>
                            </select>
                            <div class="edition-description" id="description1">Select an edition to
                                view its description</div>
                        </div>
                    </td>
                    <td>
                        <div class="dropdown-container">
                            <select id="dropdown2">
                                <option value="" data-description="">Select an edition...</option>
                                <xsl:apply-templates select="item"/>
                            </select>
                            <div class="edition-description" id="description2">Select an edition to
                                view its description</div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <iframe name="first" id="f1" src="placeHolder.html"/>
                    </td>
                    <td>
                        <iframe name="second" id="f2" src="placeHolder.html"/>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="item">
        <xsl:variable name="getURLbase">
            <xsl:value-of select="substring-before(@code, '.xml')"/>
        </xsl:variable>
        <xsl:variable name="getVolume">
            <xsl:value-of select="substring-before(@code, '_')"/>
        </xsl:variable>
        <option xmlns="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="value">
                <xsl:value-of select="concat('../HTML/', $getVolume, '/', $getURLbase, '.html')"/>
            </xsl:attribute>
            <xsl:attribute name="data-description">
                <xsl:for-each select="$getVolume">
                    <xsl:value-of
                        select="normalize-space(document('editions.xml')/tei:TEI/tei:text/tei:body/tei:list/tei:label[@xml:id = $getVolume/current()]/following-sibling::tei:item[1])"
                    />
                </xsl:for-each>
            </xsl:attribute>
            <xsl:for-each select="$getVolume">
                <xsl:value-of
                    select="normalize-space(document('editions.xml')/tei:TEI/tei:text/tei:body/tei:list/tei:label[@xml:id = $getVolume/current()])"
                />
            </xsl:for-each>
        </option>
    </xsl:template>

</xsl:stylesheet>
