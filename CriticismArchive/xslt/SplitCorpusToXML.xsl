<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs tei" version="2.0">
	
	<!-- script for converting XML-TEI to XML. 		
	Laura Mandell on 07032023 -->


	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="tei:teiCorpus">
       <xsl:for-each select="tei:TEI">
            <xsl:result-document href="../XML/{tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno}.xml"> 
            	<TEI xmlns="http://www.tei-c.org/ns/1.0">
            		<xsl:apply-templates/>
            	</TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- instead of pulling from the corpus header, I manually copied from it into this xslt. -->
	
	<xsl:template match="tei:teiHeader">
		<teiHeader xmlns="http://www.tei-c.org/ns/1.0">
			<fileDesc>
					<titleStmt>
						<xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:title"/>
						<xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:author"/>
						<editor>
							<name>Dionysius Lardner</name>
						</editor>
						<respStmt>
							<resp>Editor</resp>
							<name xml:id="MW">Mary A. Waters</name>
						</respStmt>
						<respStmt>
							<resp>Co-Editor</resp>
							<name xml:id="LD">Laura DeWitt</name>
						</respStmt>
						<respStmt>
							<resp>Encoding Assistance</resp>
							<name xml:id="GR">Gabrielle Ramirez</name>
						</respStmt>
					</titleStmt>
					<xsl:apply-templates select="tei:fileDesc/tei:publicationStmt"/>
					<xsl:apply-templates select="tei:fileDesc/tei:sourceDesc"/>
			</fileDesc>
			<encodingDesc>
			<editorialDecl>
				<quotation>
					<p>All quotation marks and apostrophes have been transcribed as entity
						references.</p>
					<p>Quotation marks that indicate block quotes have been silently eliminated.</p>
				</quotation>
				<hyphenation eol="none">
					<p>Any dashes occurring in line breaks have been removed.</p>
					<p>Because of web browser variability, all colons and hyphens have been typed on
						the U.S. keyboard; dashes have been rendered as two hyphens.</p>
				</hyphenation>
				<normalization method="silent">
					<p>Long "s" (&#383;) has been silently modernized.</p>
					<p>Page numbers appear at the beginning of each page, no matter where originally
						placed.</p>
					<p>Compositors' catchwords and running titles have been silently eliminated.</p>
					<p>Spelling has not been regularized.</p>
				</normalization>
				<normalization method="markup">
					<p>&amp; has been used for the ampersand sign.</p>
					<p>All other characters, those with accents, non-breaking spaces, etc., have
						been encoded in HTML entity decimals.</p>
					<p>Writing in other hands appearing on these manuscripts has been indicated as
						such, the content recorded in brackets.</p>
				</normalization>
			</editorialDecl>
			<tagsDecl>
				<rendition xml:id="indent" scheme="css">text-indent: 10px; display:
					block;</rendition>
				<rendition xml:id="indent1" scheme="css">text-indent: 20px; display:
					block;</rendition>
				<rendition xml:id="indent2" scheme="css">text-indent: 30px; display:
					block;</rendition>
				<rendition xml:id="indent3" scheme="css">text-indent: 40px; display:
					block;</rendition>
				<rendition xml:id="indent4" scheme="css">text-indent: 50px; display:
					block;</rendition>
				<rendition xml:id="indent5" scheme="css">text-indent: 60px; display:
					block;</rendition>
				<rendition xml:id="indent6" scheme="css">text-indent: 70px; display:
					block;</rendition>
				<rendition xml:id="indent7" scheme="css">text-indent: 80px; display:
					block;</rendition>
				<rendition xml:id="indent8" scheme="css">text-indent: 90px; display:
					block;</rendition>
				<rendition xml:id="indent9" scheme="css">text-indent: 100px; display:
					block;</rendition>
				<rendition xml:id="indent10" scheme="css">text-indent: 110px; display:
					block;</rendition>
				<rendition xml:id="indent11" scheme="css">text-indent: 120px; display:
					block;</rendition>
				<rendition xml:id="indent12" scheme="css">text-indent: 130px; display:
					block;</rendition>
				<rendition xml:id="indent13" scheme="css">text-indent: 140px; display:
					block;</rendition>
				<rendition xml:id="indent14" scheme="css">text-indent: 150px; display:
					block;</rendition>
				<rendition xml:id="indent15" scheme="css">text-indent: 160px; display:
					block;</rendition>
				<rendition xml:id="indent20" scheme="css">text-indent: 210px; display:
					block;</rendition>
				<rendition xml:id="indent25" scheme="css">text-indent: 260px; display:
					block;</rendition>
				<rendition xml:id="indent30" scheme="css">text-indent: 310px; display:
					block;</rendition>
			</tagsDecl>
			<classDecl>
				<taxonomy xml:id="ft">
					<bibl>Full Text or Citation</bibl>
					<category xml:id="ft1">
						<catDesc>full text</catDesc>
					</category>
					<category xml:id="ft2">
						<catDesc>citation only</catDesc>
					</category>
				</taxonomy>
				<taxonomy xml:id="ps">
					<bibl>Primary or Secondary</bibl>
					<category xml:id="ps1">
						<catDesc>primary</catDesc>
					</category>
					<category xml:id="ps2">
						<catDesc>secondary</catDesc>
					</category>
				</taxonomy>
				<taxonomy xml:id="g">
					<bibl>Genre</bibl>
					<category xml:id="g1">
						<catDesc>biography</catDesc>
					</category>
					<category xml:id="g2">
						<catDesc>poetry</catDesc>
					</category>
					<category xml:id="g3">
						<catDesc>story</catDesc>
					</category>
					<category xml:id="g4">
						<catDesc>drama</catDesc>
					</category>
					<category xml:id="g5">
						<catDesc>novel</catDesc>
					</category>
					<category xml:id="g6">
						<catDesc>satire</catDesc>
					</category>
					<category xml:id="g7">
						<catDesc>allegory</catDesc>
					</category>
					<category xml:id="g8">
						<catDesc>advertisement</catDesc>
					</category>
					<category xml:id="g9">
						<catDesc>preface</catDesc>
					</category>
					<category xml:id="g10">
						<catDesc>preface</catDesc>
					</category>
					<category xml:id="g11">
						<catDesc>introduction</catDesc>
					</category>
					<category xml:id="g12">
						<catDesc>acknowledgments</catDesc>
					</category>
					<category xml:id="g13">
						<catDesc>essay</catDesc>
					</category>
					<category xml:id="g14">
						<catDesc>review</catDesc>
					</category>
					<category xml:id="g15">
						<catDesc>letter</catDesc>
					</category>
					<category xml:id="g16">
						<catDesc>literary criticism</catDesc>
					</category>
					<category xml:id="g17">
						<catDesc>biography</catDesc>
					</category>
					<category xml:id="g18">
						<catDesc>bibliography</catDesc>
					</category>
					<category xml:id="g19">
						<catDesc>music</catDesc>
					</category>
					<category xml:id="g20">
						<catDesc>political statement</catDesc>
					</category>
					<category xml:id="g21">
						<catDesc>history</catDesc>
					</category>
					<category xml:id="g22">
						<catDesc>education</catDesc>
					</category>
					<category xml:id="g23">
						<catDesc>sermon</catDesc>
					</category>
					<category xml:id="g24">
						<catDesc>religion</catDesc>
					</category>
					<category xml:id="g25">
						<catDesc>philosophical statement</catDesc>
					</category>
					<category xml:id="g26">
						<catDesc>translation</catDesc>
					</category>
					<category xml:id="g27">
						<catDesc>dictionary</catDesc>
					</category>
					<category xml:id="g28">
						<catDesc>encyclopedia</catDesc>
					</category>
					<category xml:id="g29">
						<catDesc>travel</catDesc>
					</category>
					<category xml:id="g30">
						<catDesc>illustration</catDesc>
					</category>
					<category xml:id="g31">
						<catDesc>map</catDesc>
					</category>
					<category xml:id="g32">
						<catDesc>floorplans</catDesc>
					</category>
					<category xml:id="g33">
						<catDesc>photograph</catDesc>
					</category>
					<category xml:id="g34">
						<catDesc>cartoon</catDesc>
					</category>
					<category xml:id="g35">
						<catDesc>literary annual</catDesc>
					</category>
					<category xml:id="g36">
						<catDesc>miscellany</catDesc>
					</category>
					<category xml:id="g37">
						<catDesc>anthology</catDesc>
					</category>
					<category xml:id="g38">
						<catDesc>beauties</catDesc>
					</category>
					<category xml:id="g39">
						<catDesc>juvenile</catDesc>
					</category>
				</taxonomy>
				<taxonomy xml:id="f">
					<bibl>Form</bibl>
					<category xml:id="f1">
						<catDesc>pageimage</catDesc>
					</category>
					<category xml:id="f2">
						<catDesc>book part</catDesc>
					</category>
					<category xml:id="f3">
						<catDesc>book</catDesc>
					</category>
					<category xml:id="f4">
						<catDesc>periodical part</catDesc>
					</category>
					<category xml:id="f5">
						<catDesc>periodical</catDesc>
					</category>
					<category xml:id="f6">
						<catDesc>fragment</catDesc>
					</category>
					<category xml:id="f7">
						<catDesc>frontispiece</catDesc>
					</category>
					<category xml:id="f8">
						<catDesc>title page</catDesc>
					</category>
					<category xml:id="f9">
						<catDesc>inscription page</catDesc>
					</category>
					<category xml:id="f10">
						<catDesc>dedication</catDesc>
					</category>
					<category xml:id="f11">
						<catDesc>table of contents</catDesc>
					</category>
					<category xml:id="f12">
						<catDesc>table of illustrations</catDesc>
					</category>
					<category xml:id="f13">
						<catDesc>list of subscribers</catDesc>
					</category>
					<category xml:id="f14">
						<catDesc>index</catDesc>
					</category>
					<category xml:id="f15">
						<catDesc>notes</catDesc>
					</category>
					<category xml:id="f16">
						<catDesc>book boards</catDesc>
					</category>
					<category xml:id="f17">
						<catDesc>slipcase</catDesc>
					</category>
					<category xml:id="f18">
						<catDesc>printers mark</catDesc>
					</category>
					<category xml:id="f19">
						<catDesc>engraving</catDesc>
					</category>
					<category xml:id="f20">
						<catDesc>pamphlet</catDesc>
					</category>
					<category xml:id="f21">
						<catDesc>manuscript</catDesc>
					</category>
					<category xml:id="f22">
						<catDesc>collection</catDesc>
					</category>
					<category xml:id="f23">
						<catDesc>nonceCollection</catDesc>
					</category>
					<category xml:id="f24">
						<catDesc>sammelband</catDesc>
					</category>
				</taxonomy>
				<taxonomy xml:id="keyword">
					<category xml:id="lcna">
						<catDesc>author of main text and of works reviewed, if relevant, using LOC
							authority name headings.</catDesc>
					</category>
				</taxonomy>
			</classDecl>
		</encodingDesc>
		<profileDesc>
			<textClass>
				<keywords scheme="#lcna">
					<list type="simple">
						<item>Shelley, Mary Wollstonecraft, 1797-1851</item>
						<item>Mazzini, Giuseppe, 1805-1872</item>
						<item>Manzoni, Alessandro, 1785-1873</item>
						<item>Azeglio, Massimo d', 1798-1866</item>
						<item>Guerrazzi, Francesco Domenico, 1804-1873</item>
					</list>
				</keywords>
				<catRef scheme="#ft" target="#ft1"/>
				<catRef scheme="#p" target="#ps1"/>
				<catRef scheme="#g" target="#g14 #g16"/>
				<catRef scheme="#f" target="#f4"/>
			</textClass>
		</profileDesc>
		<revisionDesc>
				<change who="#LM" when="20230227">
					<label>Changed by</label>
					<name>Laura Mandell</name>
					<list type="simple">
						<item>new header</item>
					</list>
				</change>
				<change who="#GR" when="20230111">
					<label>Changed by</label>
					<name>Gabrielle Ramirez</name>
					<list type="simple">
						<item>revised keywords</item>
						<item>correct encoding errors</item>
					</list>
				</change>
			<change who="#MW" when="20220930">
				<label>Changed by</label>
				<name>Mary A. Waters</name>
				<list type="simple">
					<item>Added attribution information</item>
				</list>
			</change>
			<change who="#MW" when="20220525">
				<label>Changed by</label>
				<name>Mary A. Waters</name>
				<list type="simple">
					<item>Added corpus information</item>
				</list>
			</change>
			<change who="#MW" when="20210720">
				<label>Changed by</label>
				<name>Mary A. Waters</name>
				<list type="simple">
					<item>Revised encoding and editing</item>
				</list>
			</change>
			<change who="#LD" when="20210524">
				<label>Changed by</label>
				<name>Laura DeWitt</name>
				<list type="simple">
					<item>TEI encoding</item>
					<item>Changed editing</item>
				</list>
			</change>
			<change who="#MW" when="20181113">
				<label>Changed by</label>
				<name>Mary A. Waters</name>
				<list type="simple">
					<item>Created Edition</item>
				</list>
			</change>
		</revisionDesc>
		</teiHeader>
	</xsl:template>
	
</xsl:stylesheet>