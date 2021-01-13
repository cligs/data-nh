<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:cligs="https://cligs.hypotheses.org/ns/cligs"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- 
        @author: Ulrike Henny-Krahmer
        
        This script produces a CSV file containing metadata about the novels.
        
        How to call the script:
        java -jar /home/ulrike/Programme/saxon/saxon9he.jar /home/ulrike/Git/conha19/tei/nh0001.xml /home/ulrike/Git/papers/family_resemblance_dsrom19/metadata.xsl > /home/ulrike/Git/papers/family_resemblance_dsrom19/metadata.csv
    -->
    
    
    <xsl:variable name="corpus-dir" select="'/home/ulrike/Git/conha19/tei/'"/>
    <xsl:variable name="decades" select="('1840-1850','1851-1860','1861-1870','1871-1880','1881-1890','1891-1900','1901-1910')"/>
    
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:text>"idno","author-short","author-gender","title-short","author-long","title-long","year","decade","country","source-edition","narrative-perspective","subgenre-theme","subgenre-current"</xsl:text><xsl:text>
</xsl:text>
        <xsl:for-each select="collection($corpus-dir)//TEI">
            <xsl:sort select=".//idno[@type='cligs']"/>
            <xsl:value-of select=".//idno[@type='cligs']"/><xsl:text>,</xsl:text>
            <xsl:value-of select=".//author/name[@type='short']"/><xsl:text>,</xsl:text>
            <xsl:value-of select=".//term[@type='author.gender']"/><xsl:text>,</xsl:text>
            <xsl:value-of select=".//title[@type='short']"/><xsl:text>,</xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select=".//author/name[@type='full']"/><xsl:text>",</xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select=".//title[@type='main']/normalize-space(.)"/><xsl:text>",</xsl:text>
            <xsl:variable name="year" select=".//bibl[@type='edition-first']//date/@when"/>
            <xsl:value-of select="$year"/><xsl:text>,</xsl:text>
            <xsl:value-of select="cligs:get-decade($year)"/><xsl:text>,</xsl:text>
            <xsl:value-of select=".//term[@type='author.country']"/><xsl:text>,</xsl:text>
            <xsl:value-of select=".//term[@type='text.source.edition']"/><xsl:text>,</xsl:text>
            <xsl:value-of select=".//term[@type='text.narration.narrator']"/><xsl:text>,</xsl:text>
            <xsl:choose>
                <xsl:when test=".//term[contains(@type,'text.genre.subgenre.summary.theme')][@cligs:importance]">
                    <xsl:text>"</xsl:text><xsl:value-of select=".//term[contains(@type,'text.genre.subgenre.summary.theme')][@cligs:importance='2']/normalize-space(.)"/><xsl:text>",</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>"</xsl:text><xsl:value-of select=".//term[contains(@type,'text.genre.subgenre.summary.theme')]/normalize-space(.)"/><xsl:text>",</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test=".//term[contains(@type,'text.genre.subgenre.summary.current')][@cligs:importance]">
                    <xsl:text>"</xsl:text><xsl:value-of select=".//term[contains(@type,'text.genre.subgenre.summary.current')][@cligs:importance='2']/normalize-space(.)"/><xsl:text>"</xsl:text>
                </xsl:when>
                <xsl:when test=".//term[contains(@type,'text.genre.subgenre.summary.current')]">
                    <xsl:text>"</xsl:text><xsl:value-of select=".//term[contains(@type,'text.genre.subgenre.summary.current')]/normalize-space(.)"/><xsl:text>"</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>unknown</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position() != last()">
                <xsl:text>
</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:function name="cligs:get-decade" as="xs:string*">
        <xsl:param name="year" as="xs:integer"/>
        <xsl:if test="not($year >= 1840 and $year &lt;= 1910)">
            <xsl:message terminate="yes">
                Error: the edition year <xsl:value-of select="$year"/> is out of range.
            </xsl:message>
        </xsl:if>
        <xsl:for-each select="$decades">
            <xsl:variable name="pos" select="position()"/>
            <xsl:variable name="decade-start" select="substring-before($decades[$pos],'-')"/>
            <xsl:variable name="decade-end" select="substring-after($decades[$pos],'-')"/>
            <xsl:if test="xs:integer($decade-start) &lt;= $year and $year &lt;= xs:integer($decade-end)">
                <xsl:value-of select="current()"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
</xsl:stylesheet>