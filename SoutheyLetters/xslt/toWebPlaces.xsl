<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="3.0">

    <!--  =======================================================
		revision history
	00-began with fork from /xslt/masters/HTMLtransform.xsl
	01-filled master with needed code
	02-revised plays, simplified by eliminating TOC
	03-created for CritArchive 
	04-changes 09/20/2021
	05-new, combining LL, LM, and SN, as of 8/24/22
	06-revised for P4H Fall 2022, as of 11/18/22
	07-revised for Southey 07/2026
	-->

    <!-- =======================================================
		running documents -->

    <xsl:output method="xhtml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:TEI">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
            <html xml:lang="en" lang="en" id="idno"
                prefix="og: http://ogp.me/ns# dcterms: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/">
                <xsl:comment>This HTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
                <xsl:apply-templates/>
            </html>
    </xsl:template>

    <xsl:template match="tei:teiHeader">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <title>Places, Southey Letters</title>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <meta name="author" content="Lynda Pratt"/>
            <meta name="DC.Title" content="Places, Southey Letters"/>
            <meta name="DC.Type" content="Text"/>
            <meta name="DC.Format" content="text/html"/>
            <meta property="og:title" content="Places, Southey Letters"/>
            <meta property="og:type" content="website"/>
            <meta property="og:url"
                content="https://cha.artsci.tamu.edu/SoutheyLetters/HTML/paratext/places.html"/>
            <meta property="og:image"
                content="https://cha.artsci.tamu.edu/SoutheyLetters/images/RClogo.png"/>
            <meta property="og:description" content="Letters written by Robert Southey (1774-1843)"/>
            <meta property="og:site_name" content="The Collected Letters of Roberty Southey"/>
            <meta property="rc:id" content="places"/>
            <meta property="dc.contributor" content="Lynda Pratt"/>
            <meta property="dc.contributor" content="Laura Mandell"/>
            <meta property="dc:date" content="2009 to present"/>
            <meta property="dcterms.available" content="2026-09-15"/>
            <meta property="dc.publisher" content="Romantic Circles"/>
            <meta property="dc.source" content="https://cha.artsci.tamu.edu/SoutheyLetters"/>
            <meta property="dc.type" content="Text"/>
            <meta property="dc.format" content="text/html"/>
            <meta property="dc.identifier" content="https://cha.artsci.tamu.edu/SoutheyLetters/HMTL/paratext/places.html" />
            <meta name="docTitle" class="staticSearch_docTitle" content="Places" />
            <meta name="docAuthor" class="staticSearch_docAuthor" content="Lynda Pratt" />
            <meta name="Date Written" class="staticSearch_date" content="2009" />
            <meta name="docSortKey" class="staticSearch_docSortKey" content="places" />
            <meta name="viaf" content="http://viaf.org/viaf/61576896" />
            <meta name="viaf" content="http://viaf.org/viaf/118520952" />
            <meta name="viaf" content="http://viaf.org/viaf/250654121" />
            <meta name="viaf" content="http://viaf.org/viaf/41749340" />
            <meta name="Wikidata" content="https://www.wikidata.org/entity/Q36279"/>
            <meta name="Wikidata" content="https://www.wikidata.org/entity/Q216838" />
            <meta name="Wikidata" content="https://www.wikidata.org/entity/Q5977111" />
            <meta name="Wikidata" content="https://www.wikidata.org/entity/Q1277575" />
            <link rel="stylesheet" href="../../css/southey.css"/>
            <link rel="icon" type="image/svg" href="../../images/favicon.ico"/>
            <link rel="preconnect" href="https://fonts.googleapis.com"/>
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
            <link
                href="https://fonts.googleapis.com/css2?family=Baskervville:ital,wght@0,400..700;1,400..700&amp;family=Pinyon+Script&amp;family=Space+Mono:ital,wght@0,400;0,700;1,400;1,700&amp;display=swap"
                rel="stylesheet"/>
            <style>
                .tblPlaces {width: 740px; border: none;}
                .placeName {width: 200px; padding-right: 30px;}
                .location {width: 340px;}
            </style>
        </head>
    </xsl:template>

    <xsl:template match="tei:text">
        <body>
            <nav id="top">
                <p class="navTitle"><a href="../../index.html">The Collected Letters of Robert
                        Southey</a><br/>Gen. Ed. Lynda Pratt</p>
                <p class="homePlink">
                    <a href="index.html">
                        <img src="../../images/GretaHall3.png" alt="Greta Hall home button"
                            class="homeButton"/>
                    </a>
                </p>
                <ul class="nav">
                    <li class="nav">
                        <span class="drop">Parts</span>
                        <ul class="dropdown">
                            <li>
                                <a href="../../index.html">All</a>
                            </li>
                            <li>
                                <a href="../Part_One/index.html">One (1791-1797)</a>
                            </li>
                            <li>
                                <a href="../Part_Two/index.html">Two (1798-1803)</a>
                            </li>
                            <li>
                                <a href="../Part_Three/index.html">Three (1804-1809)</a>
                            </li>
                            <li>
                                <a href="../Part_Four/index.html">Four (1810-1815)</a>
                            </li>
                            <li>
                                <a href="../Part_Five/index.html">Five (1816-1818)</a>
                            </li>
                            <li>
                                <a href="../Part_Six/index.html">Six (1819-1821)</a>
                            </li>
                            <li>
                                <a href="../Part_Seven/index.html">Seven (1822-1824)</a>
                            </li>
                            <li>
                                <a href="../Part_Eight/index.html">Eight (1825-1827)</a>
                            </li>
                            <li>
                                <a href="../Part_Nine/index.html">Nine (1828-1830)</a>
                            </li>
                            <li>
                                <a href="../Part_Ten/index.html">Ten (1831-1833)</a>
                            </li>
                            <li>
                                <a href="../Part_Eleven/index.html">Eleven (1834-1836)</a>
                            </li>
                            <li>
                                <a href="../Part_Twelve/index.html">Twelve (1837-1839)</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav">
                        <span class="drop">People</span>
                        <ul class="dropdown">
                            <li>
                                <a href="../paratext/people.html">All</a>
                            </li>
                            <li>
                                <a href="../paratext/corresp.html">Correspondents</a>
                            </li>
                            <li>
                                <a href="../paratext/mentioned.html">People mentioned</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav">
                        <span class="here">Places</span>
                    </li>
                    <li class="nav">
                        <a href="../paratext/chrono.html">Chronology</a>
                    </li>
                    <li class="nav">
                        <span class="drop">Appendices</span>
                        <ul class="dropdown">
                            <li>
                                <a href="../paratext/appendices.html">All</a>
                            </li>
                            <li>
                                <a href="../paratext/appendix1.html">Appendix 1</a>
                            </li>
                            <li>
                                <a href="../paratext/appendix2.html">Appendix 2</a>
                            </li>
                            <li>
                                <a href="../paratext/appendix3.html">Appendix 3</a>
                            </li>
                            <li>
                                <a href="../paratext/appendix4.html">Appendix 4</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav">
                        <a href="../search.html">Search</a>
                    </li>
                </ul>
            </nav>
            <main>
                <xsl:apply-templates select="tei:body/tei:div"/>
            </main>
        </body>
    </xsl:template>

    <!-- 
		 =======================================================
			structural elements in all documents-->

    <xsl:template match="tei:div">
        <div class="paratext">
        <h1>The Collected Letters of Robert Southey</h1>
        <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <h2>Places</h2>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:listPlace">
        <table class="tblPlaces">
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="tei:place">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="tei:placeName">
        <td class="placeName">
            <p>
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:attribute name="data-longitude">
                    <xsl:value-of select="following-sibling::tei:location/tei:geo[@select='long']"/>
                </xsl:attribute>
                <xsl:attribute name="data-latitude">
                    <xsl:value-of select="following-sibling::tei:location/tei:geo[@select='lat']"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </p>
        </td>
    </xsl:template>
    
    <xsl:template match="tei:location">
        <td class="location">
            <p>
                <xsl:apply-templates select="tei:desc"/>
            </p>
        </td>
    </xsl:template>

</xsl:stylesheet>
