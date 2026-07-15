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

	<xsl:param name="css">../../css/southey.css</xsl:param>
	<xsl:param name="baseURLpeople">../paratext/people.html</xsl:param>
	<xsl:variable name="docID" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']"/>
	<xsl:variable name="letDate" select="substring-before(tei:TEI/tei:text/tei:body/tei:div[@type='letter']/tei:head/tei:date/@when, '-')"/>
	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="list">
		<xsl:for-each select="item">
			<xsl:apply-templates select="document(@code)/tei:TEI"/>
		</xsl:for-each>
	</xsl:template>


	<!-- =======================================================
		document structure -->

	<xsl:template match="tei:TEI">
		<xsl:result-document href="../HTML/{$docID}.html">
			<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
			<html xml:lang="en" lang="en" id="idno" prefix="og: http://ogp.me/ns# dcterms: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/">
				<xsl:comment>This HTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
				<xsl:apply-templates/>
			</html>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="tei:teiHeader">
		<xsl:variable name="headTitle">
			<xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title[@level='a'], ' ', tei:fileDesc/tei:titleStmt/tei:title[@level='m']"/>
		</xsl:variable>
		<xsl:variable name="getPath">
			<xsl:value-of select="tei:fileDesc/tei:editionStmt/tei:edition/@n"/>
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
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			<title><xsl:value-of select="$headTitle"/></title>
			<meta name="viewport" content="width=device-width, initial-scale=1"/>
			<meta name="author" content="Robert Southey" />
			<meta name="DC.Title" content="{$headTitle}" />
			<meta name="DC.Type" content="Text" />
			<meta name="DC.Format" content="text/html" />
			<meta property="og:title" content="{$headTitle}" />
			<meta property="og:type" content="website" />
			<meta property="og:url" content="https://cha.artsci.tamu.edu/SoutheyLetters/{$ptPath}/{$docID}.html" /> <!--add path -->
			<meta property="og:image"
				content="https://cha.artsci.tamu.edu/SoutheyLetters/images/RClogo.png" />
			<meta property="og:description" content="Letters written by Robert Southey (1774-1843)" />
			<meta property="og:site_name" content="The Collected Letters of Roberty Southey" />
			<meta property="rc:id" content="{$docID}" />
			<meta property="dc.contributor" content="Lynda Pratt" />
			<meta property="dc.contributor" content="Laura Mandell" />
			<meta property="dc:date" content="{$letDate}" />
			<meta property="dcterms.available" content="2026-07-20" />
			<meta property="dc.publisher" content="Romantic Circles" />
			<meta property="dc.source" content="https://cha.artsci.tamu.edu/SoutheyLetters" />
			<meta property="dc.type" content="Text" />
			<meta property="dc.format" content="text/html" />
			<!-- put in static search metas -->
			<link rel="stylesheet" type="text/css" href="{$css}"/>
			<link rel="icon" type="image/svg" href="../../images/favicon.ico"/>
			<link rel="preconnect" href="https://fonts.googleapis.com"/>
			<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
			<link
				href="https://fonts.googleapis.com/css2?family=Baskervville:ital,wght@0,400..700;1,400..700&amp;family=Pinyon+Script&amp;family=Space+Mono:ital,wght@0,400;0,700;1,400;1,700&amp;display=swap"
				rel="stylesheet"/>
			<xsl:if test="tei:encodingDesc/tei:tagsDecl">
				<style>
					<xsl:for-each select="tei:rendition">
						<xsl:value-of select="concat('.', @xml:id, ' {')"/>
						<xsl:value-of select="."/>
						<xsl:text>}</xsl:text>
					</xsl:for-each>
				</style>
			</xsl:if>
		</head>
	</xsl:template>

	<xsl:template match="tei:text">
		<body>
			<xsl:if test="tei:front">
				<xsl:apply-templates select="tei:front"/>
			</xsl:if>
			<main>
				<xsl:apply-templates select="tei:body"/>
			</main>
			<xsl:if test="tei:back">
				<xsl:apply-templates select="tei:back"/>
			</xsl:if>
			<xsl:if test="//tei:note">
				<section class="notes">
					<h2>Notes</h2>
					<xsl:apply-templates select="//tei:note" mode="end"/>
				</section>
				<section class="noteSpace">
					<h2>HTML constraints</h2>
					<p>Makes enough space, 60em in the css, at the end of webpage for the note link
						to bring the specified note to the top of the screen.</p>
				</section>
			</xsl:if>
		</body>
	</xsl:template>

	<!-- =======================================================
	   front templates -->

	<xsl:template match="tei:front">
		<div class="front">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:titlePage">
		<xsl:if test="@facs">
			<a target="_blank">
				<xsl:attribute name="href">
					<xsl:value-of select="concat('../images/', @facs)"/>
				</xsl:attribute>
			<img class="imageTP" alt="an image of the title page">
				<xsl:attribute name="src">
					<xsl:value-of select="concat('../images/', @facs)"/>
				</xsl:attribute>
			</img>
			</a>
		</xsl:if>
		<div class="tp">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:titlePart">
		<h2 class="tp">
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	<xsl:template match="tei:byline">
		<span class="byline">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:docAuthor">
		<h3 class="tp">
			<xsl:apply-templates/>
		</h3>
	</xsl:template>

	<xsl:template match="tei:docDate">
		<span class="tpDate">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:pubPlace">
		<span class="tpPlace">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:publisher">
		<span class="tpPub">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:imprimatur">
		<span class="tpImprimatur">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:docImprint">
		<p class="noindent tpPubInfo">
			<xsl:if test="tei:pubPlace">
				<xsl:apply-templates select="tei:pubPlace"/>
			</xsl:if>
			<xsl:if test="tei:publisher">
				<xsl:apply-templates select="tei:publisher"/>
			</xsl:if>
			<xsl:if test="tei:docDate">
				<xsl:apply-templates select="tei:docDate"/>
			</xsl:if>
			<xsl:if test="tei:date">
				<xsl:apply-templates select="tei:date"/>
			</xsl:if>
		</p>
	</xsl:template>

	<xsl:template match="tei:docEdition">
		<xsl:choose>
			<xsl:when test="tei:bibl/tei:biblScope/@unit">
				<p>
					<xsl:text>Vol. </xsl:text>
					<xsl:value-of select="tei:bibl/tei:biblScope[@unit = 'volume']"/>
					<xsl:text>, </xsl:text>
					<xsl:text>pp. </xsl:text>
					<xsl:value-of select="tei:bibl/tei:biblScope[@unit = 'page']"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p class="tp">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
		 =======================================================
			structural elements all documents-->
	
	<xsl:template match="tei:div | tei:div1 | tei:div2">
		<div>
			<xsl:attribute name="class" select="@type"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:head">
		<header>
			<xsl:apply-templates/>
		</header>
	</xsl:template>
	
	<xsl:template match="tei:p">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type">
					<xsl:attribute name="class" select="@type"/>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	<xsl:template match="tei:lg">
		<span class="stanza">
			<xsl:apply-templates/>
		</span>
		<span class="stanzaSpace">&#160;</span>
	</xsl:template>
	
	<xsl:template match="tei:l">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:value-of select="@rend"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'l'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<span>
			<xsl:attribute name="class" select="$class"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:table">
		<table>
			<xsl:if test="@rend">
				<xsl:attribute name="class">
					<xsl:value-of select="@rend"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	
	<xsl:template match="tei:row">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>
	
	<xsl:template match="tei:cell">
		<td>
			<xsl:if test="@rendition">
				<xsl:attribute name="class" select="substring-before(@rendition, '#')"/>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>
	
	<xsl:template match="tei:lb">
				<br/>
	</xsl:template>
	
	<xsl:template match="tei:list">
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
	
	<xsl:template match="tei:item">
		<xsl:choose>
			<xsl:when test="parent::tei:list[@type = 'gloss']">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<xsl:apply-templates/>
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:term">
		<dt>
			<xsl:attribute name="id" select="@xml:id"/>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>
	
	<xsl:template match="tei:gloss">
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>
	
	<xsl:template match="tei:ref">
		<a href="{@target}" target="_blank">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	
	
	<!-- =======================================================
		   style -->
	
	<xsl:template match="tei:hi">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="@rend"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:emph">
		<em>
			<xsl:value-of select="."/>
		</em>
	</xsl:template>


	<!-- =======================================================
		figures, images, and illustrations -->
	
	<xsl:template match="tei:figure">
		<figure>
			<xsl:attribute name="class" select="@type"/>
			<xsl:apply-templates select="tei:head"/>
			<xsl:apply-templates select="tei:graphic"/>
			<figcaption><xsl:apply-templates select="tei:figDesc"/></figcaption>
		</figure>
	</xsl:template>
	
	<xsl:template match="tei:figure/tei:head">
		<header><span class="figureHead"><xsl:apply-templates/></span></header>
	</xsl:template>
	
	<xsl:template match="tei:graphic">
		<a target="_blank">
			<xsl:attribute name="href">
				<xsl:value-of select="@url"/>
			</xsl:attribute>
			<img>
				<xsl:attribute name="src">
					<xsl:value-of select="@url"/>
				</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:value-of select="parent::tei:figure/tei:head"/>
				</xsl:attribute>
				<xsl:attribute name="class">
					<xsl:value-of select="parent::tei:figure/@type"/>
				</xsl:attribute>
			</img>
		</a>
	</xsl:template>
	
	
	<!-- =======================================================
	      bibliographic and quotations -->


	<xsl:template match="tei:bibl">
		<xsl:choose>
			<xsl:when test="parent::tei:head/parent::tei:div[@type = 'essay']">
				<!-- why not for poem? because the poem div starts after header info.-->
				<header class="headBibl">
					<xsl:apply-templates/>
				</header>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:div/tei:head/tei:bibl/tei:author">
		<span class="author">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:head/tei:bibl/tei:title">
		<span class="titleHeader">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:title">
		<!-- this hasn't been tested -->
		<xsl:variable name="class1">
			<xsl:choose>
				<xsl:when test="@level = 'a' or @level = 's' or @level = 'u'">
					<xsl:value-of select="'titlePart'"/>
				</xsl:when>
				<xsl:when test="@level = 'm' or @level = 'j'">
					<xsl:value-of select="'titleWhole'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="class2">
			<xsl:choose>
				<xsl:when test="@type = 'main'">
					<xsl:value-of select="'titleMain'"/>
				</xsl:when>
				<xsl:when test="@type = 'sub'">
					<xsl:value-of select="'titleSub'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<span>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="@level or @type">
						<xsl:choose>
							<xsl:when test="$class1 != '' and $class2 != ''">
								<xsl:value-of select="$class1"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$class2"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$class1">
										<xsl:value-of select="$class1"/>
									</xsl:when>
									<xsl:when test="$class2">
										<xsl:value-of select="$class2"/>
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'title'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:epigraph">
		<div class="epigraph">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:cit">
		<p class="epigraph noindent">
		<xsl:choose>
			<xsl:when test="tei:quote/tei:l">
				<span class="stanza">
					<xsl:apply-templates select="tei:quote"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
					<xsl:apply-templates select="tei:quote"/>
			</xsl:otherwise>
		</xsl:choose>
		</p>
		<p class="cit">
			<xsl:apply-templates select="tei:bibl"/>
		</p>
	</xsl:template>
	
	<xsl:template match="tei:q">
		<xsl:text>&quot;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&quot;</xsl:text>
	</xsl:template>
	
	<xsl:template match="tei:quote">
		<xsl:choose>
			<xsl:when test="parent::tei:div">
				<div class="blockquote">
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:when test="parent::tei:p">
				<span class="blockquote">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="parent::tei:cit">
				<xsl:apply-templates/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:name">
		<span class="name">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<a name="{@xml:id}"/>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="@ref">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="$baseURLpeople = ''">
								<xsl:value-of select="@ref"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($baseURLpeople, @ref)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>

	<xsl:template match="tei:persName">
		<span class="persName">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<a name="{@xml:id}"/>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="@ref">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="concat($baseURLpeople, @ref)"/>
					</xsl:attribute>
					<xsl:if test="@type">
						<xsl:attribute name="class" select="@type"/>
					</xsl:if>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
					<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>
	
	<xsl:template match="tei:placeName">
		<xsl:choose>
			<xsl:when test="@xml:id">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="concat('places.html', @xml:id)"/>
					</xsl:attribute>
					<xsl:if test="@type">
						<xsl:attribute name="class" select="@type"/>
					</xsl:if>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<span class="{local-name()}">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:date">
		<span class="date">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<!-- =======================================================
	   letters -->

	<xsl:template match="tei:opener">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="'opener'"/>
						<xsl:text>&#160;</xsl:text>
						<xsl:attribute name="class" select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'opener'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:closer">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="'closer'"/>
						<xsl:text>&#160;</xsl:text>
						<xsl:attribute name="class" select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'closer'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:salute | tei:signed">
		<span>
				<xsl:attribute name="class">
					<xsl:value-of select="local-name()"/>
					<xsl:if test="@rend">
					<xsl:text>&#160;</xsl:text>
					<xsl:value-of select="@rend"/>
					</xsl:if>
				</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="dateline">
		<p class="dateline">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="address">
		<span class="address">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="addrLine">
		<span>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class" select="@rend"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'addrLine'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="addName">
		<span>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class" select="@rend"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'addName'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	
	<!-- =======================================================
	   notes and backmatter -->

	<xsl:template match="tei:note">
		<xsl:variable name="noteNumber">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<a>
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text>
				<xsl:value-of select="$noteNumber"/>
			</xsl:attribute>
			<xsl:attribute name="id" select="concat('back', $noteNumber)"/>
			<sup>
				<xsl:value-of select="$noteNumber"/>
			</sup>
		</a>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:note" mode="end">
		<xsl:variable name="noteNumber">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<p class="note" id="{$noteNumber}">
			<xsl:value-of select="$noteNumber"/>
			<xsl:text>.&#160;&#160;</xsl:text>
			<xsl:apply-templates/>
			<xsl:text> </xsl:text>
			<a>
				<xsl:attribute name="href">
					<xsl:text>#back</xsl:text>
					<xsl:value-of select="$noteNumber"/>
				</xsl:attribute>
				<xsl:text>Back</xsl:text>
			</a>
		</p>
	</xsl:template>

	<xsl:template match="tei:back">
		<div class="back">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

</xsl:stylesheet>
