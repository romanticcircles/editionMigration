<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

	<!-- script for converting XML-TEI to HTML. 		
	Laura Mandell on 05/27/18 
	00-began with fork from /xslt/masters/HTMLtransform.xsl
	01-filled master with needed code
	02-revised plays, simplified by eliminating TOC
	03-created for CritArchive 
	04-changes 09/20/2021 
	05-final version established 1/7/2026
	06-minor changes 3/12/2026
	07-changes for static search 4/3/2026
	08-more changes for static search, improve results 6/17/2026-->
	
 	<!-- 2026-07-18 Elisa Beshero-Bondar (ebb): 
 		refactoring the processing of the profileDesc and people_names key lookups. -->

	<!-- Here is the document declaration necessary for an HTML5 (web) page -->

	<xsl:output method="xhtml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
	<xsl:strip-space elements="*"/>

	<xsl:param name="nbrPoetryLines"/>
	<xsl:param name="stylesheet">../css/critarchive.css</xsl:param>
	<xsl:param name="baseURL">https://cha.artsci.tamu.edu/CriticismArchive</xsl:param>
	<xsl:variable name="sourceDoc" select="/" as="document-node()"/>
	<xsl:variable name="peopleNamesDoc" as="document-node()" select="doc('people_names.xml')"/>
	<xsl:key name="personLookup" match="*[local-name() = 'person']" use="@xml:id"/>
	<xsl:key name="taxonomyLookup" match="taxonomy/category" use="@xml:id"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- to run multiple files using the list.xml in th -->
	<xsl:template match="list">
		<xsl:for-each select="item">
			<xsl:apply-templates select="document(@code)/TEI"/>
		</xsl:for-each>
	</xsl:template>
	
	<!--structuring the document -->

	<xsl:template match="TEI">
		<xsl:variable name="filename" select="teiHeader/fileDesc/publicationStmt/idno"/>
		<xsl:variable name="currentLink" select="concat($baseURL, '/HTML/', $filename, '.html')"/>
		<xsl:variable name="mainTitle">
			<xsl:choose>
				<xsl:when test="teiHeader/fileDesc/titleStmt/title[@type='main']">
					<xsl:value-of select="normalize-space(teiHeader/fileDesc/titleStmt/title[@type='main'])"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(teiHeader/fileDesc/titleStmt/title[1])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="subTitle">
			<xsl:choose>
				<xsl:when test="teiHeader/fileDesc/titleStmt/title[@type='sub']">
					<xsl:value-of select="normalize-space(teiHeader/fileDesc/titleStmt/title[@type='sub'])"/>
				</xsl:when>
				<xsl:when test="teiHeader/fileDesc/titleStmt/title[@type='subordinate']">
					<xsl:value-of select="normalize-space(teiHeader/fileDesc/titleStmt/title[@type='subordinate'])"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(teiHeader/fileDesc/titleStmt/title[2])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="author">
			<xsl:choose>
				<xsl:when test="teiHeader/fileDesc/titleStmt/author">
					<xsl:value-of select="normalize-space(teiHeader/fileDesc/titleStmt/author)"/>
				</xsl:when>
				<xsl:when test="teiHeader/fileDesc/titleStmt/editor">
					<xsl:value-of select="normalize-space(teiHeader/fileDesc/titleStmt/editor)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="authorID" select="substring-after(text/body/div/head/bibl/author/ref/@target, 'people.html#')"/>
		<xsl:variable name="pubDate">
			<xsl:value-of select="teiHeader/fileDesc/sourceDesc/biblStruct/*/imprint/date/@when"/>
		</xsl:variable>
		<xsl:variable name="uniqueIDs" select="distinct-values(text//ref/substring-after(@target, 'people.html#'))" />
		<xsl:variable name="htmlPubDate" select="current-date()"/>
		<xsl:variable name="URL" select="concat('../XML/', $filename, '.xml')"/>
		<xsl:result-document href="../HTML/{$filename}.html">
			<html xml:lang="en" lang="en" id="{$filename}"
				prefix="og: http://ogp.me/ns# dcterms: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/">
				<head>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
					<meta property="og:title">
						<xsl:attribute name="content">
							<xsl:choose>
								<xsl:when test="$subTitle = ''">
									<xsl:value-of
										select="teiHeader/fileDesc/titleStmt/title"/>
									<xsl:text>, </xsl:text>
									<xsl:value-of select="$author"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$mainTitle"/>
									<xsl:text>, </xsl:text>
									<xsl:value-of select="normalize-space($subTitle)"/>
									<xsl:text>, </xsl:text>
									<xsl:value-of select="$author"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</meta>
					<meta property="og:type" content="website"/>
					<meta property="og:url" content="{$currentLink}"/>
					<meta property="og:image" content="{$baseURL}/images/RCLogo.png"/>
					<meta property="og:description" content="Literary Criticism"/>
					<meta property="og:site_name" content="The Criticism Archive"/>
					<meta property="rc:id" content="{$filename}"/>
					<meta property="dc.contributor" content="Mary A. Waters"/>
					<meta property="dc.contributor" content="Laura Mandell"/>
					<meta property="dc:date" content="{$pubDate}"/> <!-- accdg to LOC, this should be the source's date -->
					<meta property="dcterms.available">
						<xsl:attribute name="content">
							<xsl:value-of select="format-date(xs:date($htmlPubDate), '[Y0001]-[M01]-[D01]')"/>
						</xsl:attribute>
					</meta>
					<meta property="dc.publisher" content="Romantic Circles"/>
					<meta property="dc.source" content="https://romantic-circles.org/"/>
					<meta property="dc.type" content="Text"/>
					<meta property="dc.format" content="text/html"/>
					<meta property="dc.identifier" content="{$baseURL}/XML/{$filename}"/>
					<meta name="docTitle" class="staticSearch_docTitle">
						<xsl:attribute name="content">
									<xsl:value-of
										select="$mainTitle"/>
									<xsl:text>, by </xsl:text>
									<xsl:value-of select="$author"/>
						</xsl:attribute>
					</meta>
					<meta name="docAuthor" class="staticSearc_docAuthor" content="{$author}"/>
					<meta name="Title" class="staticSearch_feat">
						<xsl:attribute name="content">
							<xsl:value-of select="$mainTitle"/>
							<xsl:if test="$subTitle != ''">
								<xsl:text>, </xsl:text>
								<xsl:value-of select="$subTitle"/>
							</xsl:if>
						</xsl:attribute>
					</meta>
					<meta name="Date of publication" class="staticSearch_date" content="{$pubDate}"/>
					<xsl:for-each select="$uniqueIDs">
						<xsl:variable name="currentID" select="current()"/>
						<xsl:choose>
							<xsl:when test="$currentID = $authorID"/>
							<xsl:otherwise>
								<meta name="People mentioned" class="staticSearch_feat">
									<xsl:attribute name="content">
										<xsl:value-of select="key('personLookup', $currentID, $peopleNamesDoc)"/>
								<!-- ebb: NOTE: How to do a key lookup: 
									1) reference your xsl:key name in the first argument as a quoted text string
									2) indicate the value you need to look up
									3) IF NEEDED: indicate the file wwhere to do the lookup if the values you're using for keys
									are stored in an external file (as in this case). 
								-->
									</xsl:attribute>
								</meta>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:if test="//term">
						<xsl:for-each select="text/body/div/list/item/term">
							<xsl:variable name="currentPerson" select="@xml:id"/>
								<meta name="People mentioned" class="staticSearch_feat">
									<xsl:attribute name="content">
										<xsl:value-of select="key('personLookup', $currentPerson, $peopleNamesDoc)"/>
								<!-- ebb: amended the line above to use the keys as defined in the external people_names.xml document. -->
									</xsl:attribute>
								</meta>
						</xsl:for-each>
					</xsl:if>
					<meta name="docSortKey" class="staticSearch_docSortKey" content="{$mainTitle}"/>
					<link rel="icon" type="image/svg" href="../images/favicon.ico"/>
					<meta name="viewport" content="width=device-width, initial-scale=1"/>
					<xsl:comment>DO NOT EDIT THIS FILE. This HTML document was generated from a TEI Master on 
					<xsl:value-of select="$htmlPubDate"/>: edit the xml master, <xsl:value-of select="concat($filename, '.xml')"/>, 
					and rerun the document using the xslt (toWebCritArcFinal.xsl) to regenerate this file. </xsl:comment>
					<title>
						<xsl:value-of select="teiHeader/fileDesc/titleStmt/title[1]"/>
						<xsl:text>, </xsl:text>
						<xsl:value-of select="$author"/>
					</title>
					<link rel="stylesheet" type="text/css" href="{$stylesheet}"/>
					<link href="https://fonts.googleapis.com/css?family=Cormorant+Garamond"
						rel="stylesheet"/>
					<link rel="icon" type="image/svg" href="../images/favicon.ico"/>
					<script src="https://hypothes.is/embed.js" async=""/>
				</head>
				<body>
					<!-- nav bar -->
					<nav>
						<div class="logo-section">
							<a href="https://romantic-circles.org/" target="_blank">
								<img class="logo" src="../images/RClogo.png"
									alt="Romantic Circles ogo"/>
							</a>
							<p class="masthead">The Criticism Archive, ed. Mary A. Waters</p>
						</div>
						<ul class="navBar">
							<li>
								<a href="../index.html">Home</a>
							</li>
							<li>
								<a href="../about.html">About</a>
							</li>
							<li>
								<a href="../works.html">Works</a>
							</li>
							<li>
								<a href="../authors/index.html">Authors</a>
							</li>
							<li>
								<a href="search.html">Search</a>
							</li>
						</ul>
					</nav>
					<main>
					<p class="docInfo">
						<xsl:variable name="genreMarkers" as="xs:string+" select="tokenize(//teiHeader/profileDesc/textClass/catRef[@scheme='#g']/@target, '\s+')"/>
						<xsl:variable name="formMarkers" as="xs:string+" select="tokenize(//teiHeader/profileDesc/textClass/catRef[@scheme='#f']/@target, '\s+')"/>
						<xsl:for-each select="($genreMarkers, $formMarkers)">
							<xsl:variable name="currentMarker" select="current() ! substring-after(., '#')"/>
							<xsl:value-of select="key('taxonomyLookup', $currentMarker, $sourceDoc)/catDesc"/>
							<xsl:if test="not(position() = last())"><xsl:text> / </xsl:text></xsl:if>
						</xsl:for-each>
						<br />
						Orig. pub. <xsl:value-of select="substring($pubDate, 1, 4)"/>
					</p>
							<p class="tei">
								<a class="tei" href="{$URL}">
									<img class="tei" src="../images/teiLogo.png" alt="TEI-encoded version"/>
								</a>
							</p>
					<xsl:apply-templates select="text"/>
					<div class="footer">
						<button onclick="copyLink('{$currentLink}')" class="navy-btn">Copy
							Link</button>
						<p class="noindent citation"><img src="../images/RClogo.png"
								alt="Romantic Circles logo" height="20" width="20"/>&#160;Ed. Mary
							A. Waters, The Criticism Archive, published by Romantic Circles, 2026. <em>Updated <xsl:value-of select="format-date(xs:date($htmlPubDate), '[M01]/[D01]/[Y0001]')"/>.</em><br/>
							<img src="../images/hyperlinkIcon.svg" alt="link icon" height="20"
								width="20"/>&#160;<xsl:value-of select="$currentLink"/></p>
					</div>
					<section class="noteSpace"/>
					</main>
					<script>
						<xsl:text disable-output-escaping="yes">
						// Accept the link as a parameter (we will call it 'url')
						function copyLink(url) {
						navigator.clipboard.writeText(url)
						.then(() => {
						alert("Copied: " + url);
						})
						.catch(err => {
						console.error("Failed to copy: ", err);
						});
						}
						</xsl:text>
					</script>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<!-- =======================================================
	   front templates -->

	<xsl:template match="front">
		<section class="titlePage">
			<xsl:apply-templates/>
		</section>
	</xsl:template>

	<xsl:template match="titlePart">
		<h2 class="tp">
			<xsl:if test="@type='main'">
			<xsl:attribute name="style">
				<xsl:value-of select="'margin-top: 5rem;'"/>
			</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>

	<xsl:template match="docAuthor">
		<h3 class="tp">
			<xsl:apply-templates/>
		</h3>
	</xsl:template>

	<xsl:template match="docDate">
		<h4 class="tp">
			<xsl:apply-templates/>
		</h4>
	</xsl:template>

	<xsl:template match="docImprint">
		<p class="noindent">
			<xsl:if test="publisher">
				<xsl:apply-templates select="publisher"/>
			</xsl:if>
			<xsl:if test="pubPlace">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="pubPlace"/>
			</xsl:if>
			<xsl:if test="date">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="date"/>
			</xsl:if>
		</p>
	</xsl:template>

	<xsl:template match="docEdition">
		<xsl:choose>
			<xsl:when test="bibl/biblScope/@unit">
				<h4 class="tp">
					<xsl:if test="bibl/biblScope[@unit = 'volume']">
						<xsl:text>Vol. </xsl:text>
						<xsl:value-of select="bibl/biblScope[@unit = 'volume']"/>
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:if test="bibl/biblScope[@unit = 'page']">
						<xsl:text>pp. </xsl:text>
						<xsl:value-of select="bibl/biblScope[@unit = 'page']"/>
					</xsl:if>
				</h4>
			</xsl:when>
			<xsl:otherwise>
				<p class="tp">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- =======================================================
	         body templates used by all types of documents -->

	<xsl:template match="text">
		<xsl:apply-templates/>
		<xsl:if test="//note">
			<section class="notes" id="notes">
				<header>Notes</header>
				<xsl:apply-templates select="//note" mode="end"/>
			</section>
		</xsl:if>
	</xsl:template>

	<xsl:template match="div">
		<div>
			<xsl:attribute name="class" select="@type"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="head">
		<!-- for static search -->
		<xsl:variable name="headerNo">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="bibl">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="parent::div[@type = 'biography']">
				<h1>
					<xsl:apply-templates/>
				</h1>
			</xsl:when>
			<xsl:otherwise>
				<header id="hdr{$headerNo}">
					<xsl:apply-templates/>
				</header>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="bibl">
		<xsl:choose>
			<xsl:when test="parent::head/parent::div[@type = 'essay']">
				<!-- why not for poem? because the poem div starts after header info.-->
				<header class="headBibl">
					<xsl:apply-templates/>
				</header>
			</xsl:when>
			<xsl:when test="@type = 'epigraph'">
				<span class="epigCite">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="div/head/bibl/author">
		<span class="author">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="div/head/bibl/title">
		<span class="title">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="epigraph[@rendition = '#poem']">
		<span class="epigraph">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="epigraph[@rendition = '#prose']">
		<p class="epigraph">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="q">
		<xsl:text>&quot;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&quot;</xsl:text>
	</xsl:template>

	<xsl:template match="quote">
		<!-- for static search -->
		<xsl:variable name="quoteNo">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="parent::div">
				<div class="blockquote" id="quot{$quoteNo}">
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<span class="blockquote" id="quot{$quoteNo}">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="lg">
		<!-- for static search -->
		<xsl:variable name="stanzaNo">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<span class="stanza" id="stanza{$stanzaNo}">
			<xsl:apply-templates/>
		</span>
		<xsl:if test="l[last()]">
			<span class="stanzaSpace">
				<xsl:text>&#160;</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="l">
		<xsl:variable name="rend" select="@rendition"/>
		<xsl:variable name="class" select="substring-after($rend, '#')"/>
		<xsl:variable name="lineNo">
			<xsl:number from="div" level="any"/>
		</xsl:variable>
		<span class="l" id="line{$lineNo}">
			<!-- for static search -->
			<xsl:choose>
				<xsl:when test="@rendition">
					<span class="{$class}">
						<xsl:apply-templates/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:if test="$nbrPoetryLines = 'yes'">
			<span class="lno">
				<xsl:value-of select="$lineNo"/>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="p">
		<xsl:variable name="rend" select="@rendition"/>
		<xsl:variable name="class" select="substring-after($rend, '#')"/>
		<!--This is for static search -->
		<xsl:variable name="paraNo">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="parent::quote/parent::p">
				<xsl:choose>
					<xsl:when test="@rendition = '#noindent'">
						<span class="noIndentP" id="para{$paraNo}">
							<!-- static search -->
							<xsl:apply-templates/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="indentP" id="para{$paraNo}">
							<!-- static search -->
							<xsl:apply-templates/>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<p id="para{$paraNo}">
					<!-- static search -->
					<xsl:choose>
						<xsl:when test="@rendition">
							<xsl:attribute name="class">
								<xsl:value-of select="$class"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="@type">
							<xsl:attribute name="class" select="@type"/>
						</xsl:when>
					</xsl:choose>
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="table">
		<xsl:variable name="tableNo">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<table id="table{$tableNo}">
			<!-- for static search -->
			<xsl:if test="@rendition">
				<xsl:attribute name="class">
					<xsl:value-of select="substring-after(@rendition, '#')"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match="row">
		<tr>
			<xsl:if test="parent::table[@rendition]">
				<xsl:attribute name="class"
					select="substring-after(parent::table/@rendition, '#')"/>
			</xsl:if>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match="cell">
		<td>
			<xsl:if test="parent::row/parent::table[@rendition]">
				<xsl:attribute name="class"
					select="substring-after(parent::row/parent::table/@rendition, '#')"/>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<xsl:template match="lb">
		<br/>
	</xsl:template>

	<xsl:template match="hi">
		<xsl:variable name="rend" select="@rendition"/>
		<xsl:variable name="class" select="substring-after($rend, '#')"/>
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="$class"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="emph">
		<em>
			<xsl:value-of select="."/>
		</em>
	</xsl:template>

	<xsl:template match="ref">
		<xsl:variable name="refNo">
			<xsl:number select="." level="any"/>
			<!--This is for staticSearch -->
		</xsl:variable>
		<a href="{@target}" target="_blank">
			<!--This is for staticSearch -->
			<xsl:attribute name="id">
				<xsl:value-of select="concat('ref', $refNo)"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="list">
		<xsl:choose>
			<xsl:when test="@type = 'gloss'">
				<dl>
					<xsl:apply-templates/>
				</dl>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<xsl:apply-templates/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="item">
		<xsl:choose>
			<xsl:when test="parent::list[@type = 'gloss']">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<xsl:apply-templates/>
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="term">
		<dt>
			<xsl:attribute name="id" select="@xml:id"/>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<xsl:template match="gloss">
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<xsl:template match="pb">
		<!--This is for static search -->
		<xsl:variable name="pageNo">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<xsl:variable name="class">
			<xsl:choose>
				<!-- could this just be, "when ancester is quote?" -->
				<xsl:when test="parent::quote/parent::div">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::quote/parent::p">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::p/parent::quote/parent::div">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::p/parent::quote">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::note/parent::quote">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::lg/parent::quote">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:when test="parent::l/parent::lg/parent::quote">
					<xsl:text>pageInside</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>pageNumber</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<span id="pg{$pageNo}">
			<xsl:attribute name="class" select="$class"/>
			<xsl:text>[Page </xsl:text>
			<xsl:value-of select="@n"/>
			<xsl:text>]</xsl:text>
		</span>
	</xsl:template>

	<xsl:template match="fw">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="@type = 'vol'">
					<xsl:choose>
						<xsl:when test="following-sibling::fw[1][@type = 'sig']">
							<xsl:choose>
								<xsl:when test="parent::quote">
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::p/parent::quote/parent::div">
									<!-- I think this is unnecessary, given the next one -->
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::p/parent::quote">
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::lg/parent::quote">
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::l/parent::lg/parent::quote">
									<xsl:text>volWithSigInside</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>volWithSig</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="parent::quote">
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::p/parent::quote/parent::div">
							<!-- I think this is unnecessary, given the next one -->
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::p/parent::quote">
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::lg/parent::quote">
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::l/parent::lg/parent::quote">
							<xsl:text>volInside</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>vol</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@type = 'sig'">
					<xsl:choose>
						<xsl:when test="preceding-sibling::fw[1][@type = 'vol']">
							<xsl:choose>
								<xsl:when test="parent::quote">
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::p/parent::quote/parent::div">
									<!-- I think this is unnecessary, given the next one -->
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::p/parent::quote">
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::lg/parent::quote">
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:when test="parent::l/parent::lg/parent::quote">
									<xsl:text>sigWithVolInside</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>sigWithVol</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="parent::quote">
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::p/parent::quote/parent::div">
							<!-- I think this is unnecessary, given the next one -->
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::p/parent::quote">
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::lg/parent::quote">
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:when test="parent::l/parent::lg/parent::quote">
							<xsl:text>sigInside</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>sig</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<span>
			<xsl:attribute name="class" select="$class"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="salute | signed">
		<p>
			<xsl:if test="@rend">
				<xsl:attribute name="class">
					<xsl:value-of select="@rend"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="imprint">
		<xsl:text>, Vol. </xsl:text>
		<xsl:value-of select="biblScope[@unit = 'volume']"/>
		<xsl:text> (</xsl:text>
		<xsl:value-of select="date"/>
		<xsl:text>), </xsl:text>
		<xsl:text>pp. </xsl:text>
		<xsl:value-of select="biblScope[@unit = 'page']"/>
	</xsl:template>

	<xsl:template match="binaryObject">
		<p>
			<xsl:value-of select="."/>
		</p>
	</xsl:template>


	<!-- =======================================================
	   notes -->

	<xsl:template match="note">
		<xsl:variable name="noteNBR">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<a>
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text>
				<xsl:value-of select="concat('note', $noteNBR)"/>
			</xsl:attribute>
			<xsl:attribute name="id" select="concat('backN', $noteNBR)"/>
			<sup>
				<xsl:value-of select="$noteNBR"/>
			</sup>
		</a>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="note" mode="end">
		<xsl:variable name="noteNBR">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<p class="note" id="note{$noteNBR}">
			<xsl:value-of select="$noteNBR"/>
			<xsl:text>.&#160;&#160;</xsl:text>
			<xsl:apply-templates/>
			<xsl:text> </xsl:text>
			<a>
				<xsl:attribute name="href">
					<xsl:text>#backN</xsl:text>
					<xsl:value-of select="$noteNBR"/>
				</xsl:attribute>
				<xsl:text>Back</xsl:text>
			</a>
		</p>
	</xsl:template>

</xsl:stylesheet>
