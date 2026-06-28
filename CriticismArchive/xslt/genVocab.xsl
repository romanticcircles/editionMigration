<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">
    <xsl:output method="xhtml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <!-- to get most current terminologies, run this xslt on any single xml document (except the corpus file), and then
    configure the output to save as vocabularies.html in the main folder-->
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:variable name="htmlPubDate" select="current-date()"/>
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"
            prefix="og: http://ogp.me/ns# dcterms: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <title>The Criticism Archive: Vocabularies</title>
                <meta name="author" content="Mary A. Waters, Laura Mandell" />
                <meta name="DC.Title" content="The Criticism Archive: Vocabularies" />
                <meta name="DC.Type" content="Text" />
                <meta name="DC.Format" content="text/html" />
                <meta property="og:title" content="The Criticism Archive: Vocabularies" />
                <meta property="og:type" content="website" />
                <meta property="og:url" content="https://cha.artsci.tamu.edu/CriticismArchive/vocabularies.html" />
                <meta property="og:image"
                    content="https://cha.artsci.tamu.edu/CriticismArchive/images/RClogo.png" />
                <meta property="og:description" content="Literary Criticism written by 19th-c Women" />
                <meta property="og:site_name" content="The Criticism Archive" />
                <meta property="dc.contributor" content="Mary A. Waters" />
                <meta property="dc.contributor" content="Laura Mandell" />
                <meta property="dc.date" content="2026" />
                <meta property="dc.publisher" content="The Poetess Archive and Romantic Circles" />
                <meta property="dc.source" content="https://cha.artsci.tamu.edu/CriticismArchive" />
                <meta property="dc.type" content="Text" />
                <meta property="dc.format" content="text/html" />
                <link rel="stylesheet" href="css/splashPara.css" />
                <link rel="icon" type="image/svg" href="images/favicon.ico" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <style>
                    .lists {
                    display: flex;
                    justify-content: space-evenly}
                    ul {
                    list-style-type: none;
                </style>
            </head>
            <body>
                <nav>
                    <div class="logo-section">
                        <a href="https://romantic-circles.org/" target="_blank"><img class="logo" src="images/RClogo.png" alt="Romantic Circles ogo"/></a>
                        <p class="masthead">The Criticism Archive, ed. Mary A. Waters</p>
                    </div>
                    <ul class="navBar">
                        <li><a href="index.html">Home</a>
                        </li>
                        <li><a href="about.html">About</a></li>
                        <li>
                            <a href="works.html">Works</a>
                        </li>
                        <li><a href="authors/index.html">Authors</a></li>
                        <li>
                            <a href="HTML/search.html">Search</a>
                        </li>
                    </ul>
                </nav>
                <main>
                    <h1 style="text-align: center;">The Criticism Archive</h1>
                    <h2 style="text-align: center;">Vocabularies</h2>
                    <div class="bibliogInfo">
                        <h3 style="text-align: center;">Poetess Archive Taxonomies</h3>
                        <div class="lists">
                            <div class="list1">
                                <h4><xsl:value-of select="tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy[@xml:id='g']/tei:bibl"/></h4>
                                <ul>
                                <xsl:for-each select="tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy[@xml:id='g']/tei:category">
                                    <li>
                                        <xsl:attribute name="id" select="@xml:id"/>
                                        <xsl:value-of select="tei:catDesc"/>
                                    </li>
                                </xsl:for-each>
                                </ul>
                            </div>
                            <div class="list2">
                                <h4><xsl:value-of select="tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy[@xml:id='f']/tei:bibl"/></h4>
                                <ul>
                                    <xsl:for-each select="tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy[@xml:id='f']/tei:category">
                                        <li>
                                            <xsl:attribute name="id" select="@xml:id"/>
                                            <xsl:value-of select="tei:catDesc"/>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </div>
                    </div>
                    </div>
                    <p>Originally published June 21, 2026<br/><em>Updated <xsl:value-of select="format-date(xs:date($htmlPubDate), '[M01]/[D01]/[Y0001]')"/>.</em></p>
                </main>
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>