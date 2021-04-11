<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- Affichage des différents paragraphes présentant le projet de l'application -->

    <xsl:template match="/">

        <!-- Ajout de mise en forme CSS -->
        <xsl:element name="style">
            <xsl:attribute name="type">
                <xsl:text>text/css</xsl:text>
            </xsl:attribute>
            <xsl:text>
                h1 {
                text-align: justify;
                padding-top: 50px;
                font-size: 35px;
                }
            
                p {
                text-align: justify;
                margin-top: 25px;
                margin-bottom: 50px;
                font-size: 24px;
                }
            </xsl:text>
        </xsl:element>

        <xsl:element name="h1">
            <xsl:value-of select="//titleStmt/title/text()"/>
        </xsl:element>

        <xsl:element name="p">
            <xsl:value-of select="//editionStmt/edition/date/text()"/>
        </xsl:element>

        <xsl:for-each select="//edition/add">
            <xsl:element name="p">
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
