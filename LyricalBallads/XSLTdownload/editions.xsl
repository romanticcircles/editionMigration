<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="3.0">
    
    <!-- transforms editions.xml into editions.html. 03/14/2026 -->
    
    <xsl:output method="xhtml" omit-xml-declaration="no" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
            <xsl:comment>Do Not Edit: this document has been created from a TEI master, editions.xml, &#10;transformed into html by editions.xsl, both in the xslt folder</xsl:comment>
        <xsl:apply-templates/>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <head xmlns="http://www.w3.org/1999/xhtml">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
            <title>Lyrical Ballads: Editions</title>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <link rel="stylesheet" href="css/LBdigEdpara.css" />
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
                <link href="https://fonts.googleapis.com/css2?family=Baskervville:ital,wght@0,400..700;1,400..700&amp;display=swap"
                            rel="stylesheet"/>
        </head>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <body xmlns="http://www.w3.org/1999/xhtml">
            <img src="header/lakeDistBanner.png" alt="banner" class="banner" />
            <nav>
                <ul id="navBar">
                    <li>
                        <a href="index.html">Home</a>
                    </li>
                    <li>
                        <a href="introduction.html">Introduction</a>
                    </li>
                    <li>
                        <a class="active" href="editions.html">Editions</a>
                    </li>
                    <li>
                        <a href="compare.html">Compare</a>
                    </li>
                    <li>
                        <a href="pageImages/index.html">Page Images</a>
                    </li>
                    <li>
                        <a href="about.html">About</a>
                    </li>
                </ul>
            </nav>
            <div class="wrapper">
                <div>
                    <div class="menu" id="toc" style="margin-top: 2rem;">
                        <h4>Copies Available:</h4>
            <xsl:apply-templates/>
                    </div>
                </div>
                <div id="frameTitle" style="margin-top: 3rem;">
                    <a href="" id="linkOutAnchor" target="_blank">
                        <img src="images/linkOut.png" alt="Open edition in a new window" class="fullView" />
                    </a>
                    <h4 id="currentView" style="margin-top: 0;">1800</h4>
                    <p id="currentDescription" style="margin: 0; font-style: italic; width: 35rem;"></p>
                </div>
                <div id="frames">
                    <iframe name="texts" id="editions" src="HTML/LB00-1.html"></iframe>
                </div>
                <p class="bottom">See a <a href="editionsList.html">simple list</a> of all copies available.</p>
            </div>
            <script>
                <xsl:text disable-output-escaping="yes">
                // Wait for the DOM to be fully loaded
                document.addEventListener('DOMContentLoaded', function () {
                // Get all the links in the table of contents
                const tocLinks = document.querySelectorAll('#toc a');
                const currentViewElement = document.getElementById('currentView');
                const linkOutAnchor = document.getElementById('linkOutAnchor');
                
                // Create the description paragraph element
                let descriptionElement = document.getElementById('currentDescription');
                if (! descriptionElement) {
                descriptionElement = document.createElement('p');
                descriptionElement.id = 'currentDescription';
                descriptionElement.style.marginTop = '0';
                descriptionElement.style.fontStyle = 'italic';
                descriptionElement.style.width = '35rem';
                currentViewElement.parentNode.insertBefore(descriptionElement, currentViewElement.nextSibling);
                }
                
                // Set initial description for LB00-1
                const initialLink = document.querySelector('a[href="HTML/LB00-1.html"]');
                if (initialLink) {
                const initialDescription = initialLink.getAttribute('data-description') || 'No description available.';
                descriptionElement.textContent = initialDescription;
                linkOutAnchor.href = initialLink.getAttribute('href');
                }
                
                
                // —— when you click any TOC link ——
                tocLinks.forEach(function (link) {
                link.addEventListener('click', function (event) {
                event.preventDefault();
                // stop any default, since target="texts" handles the iframe
                const href = this.getAttribute('href');
                
                // 1) update the header
                const linkText = this.textContent.trim();
                currentViewElement.textContent = linkText;
                
                // 2) update the description
                const description = this.dataset.description || 'No description available.';
                document.getElementById('currentDescription').textContent = description;
                
                // 3) load the iframe
                document.querySelector('iframe[name="texts"]').src = href;
                
                // 4) **update the “open in new window” link**
                linkOutAnchor.href = href;
                
                // 5) highlight the active link
                tocLinks.forEach(l => l.style.color = '');
                this.style.color = '#3f6345';
                });
                });
                });
                </xsl:text>
            </script>
        </body>
    </xsl:template>
    
    <xsl:template match="tei:list[@type='gloss']">
        <xsl:for-each select="tei:label">
            <div class="item">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <a target="texts">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('HTML/', @xml:id, '.html')"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-description">
                        <xsl:apply-templates select="normalize-space(following-sibling::tei:item[1])"/>
                    </xsl:attribute>
                    <strong><xsl:value-of select="tei:hi"/></strong>
                </a>
                <xsl:value-of select="substring-after(., tei:hi)"/>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>