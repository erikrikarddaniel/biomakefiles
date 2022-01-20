<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
    <xsl:output method="text"/>
    <xsl:template match="/">
	<xsl:for-each select="SAMPLE_SET/SAMPLE/SAMPLE_ATTRIBUTES/SAMPLE_ATTRIBUTE">
	    <xsl:value-of select="../../@accession"/><xsl:text>	</xsl:text>
	    <xsl:value-of select="TAG"/><xsl:text>_</xsl:text><xsl:value-of select="UNITS"/><xsl:text>	</xsl:text>
	    <xsl:value-of select="VALUE"/><xsl:text>
</xsl:text>
	</xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
