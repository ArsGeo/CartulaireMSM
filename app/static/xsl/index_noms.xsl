<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <xsl:element name="div">
            <xsl:element name="h2">Abbés</xsl:element>
            <xsl:call-template name="index-noms-abbes"/>
            <xsl:element name="h2">Particuliers</xsl:element>
            <xsl:call-template name="index-noms-particuliers"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="index-noms-abbes">
        <!-- Pour chaque nom d'abbé renseigné dans l'index, on ajoute, dans un paragraphe, le nom de celui-là,
        puis on déclare une variable correspondant à l'id de l'abbé en question-->
        <xsl:for-each select="//listPerson[@type = 'abbes']/person/persName">
            <!-- tri alphabétique -->
            <xsl:sort select="." order="ascending"/>
            <xsl:element name="p"><xsl:value-of select="."/> : <xsl:variable name="name_id">
                    <xsl:value-of select="./@xml:id"/>
                </xsl:variable>
                <!-- Pour chaque nom de personne balisé dans le texte cette fois-ci, on vérifie que la valeur de son pointeur est égale
                    à l'id du lieu renseigné dans l'index (égal à son pointeur sans le # donc)  -->
                <xsl:for-each
                    select="ancestor::TEI//text//persName[translate(@ref, '#', '') = $name_id]">
                    <!-- Si le test est validé, on crée un élément html <a> ayant pour attribut @href la route de la page html
                    correspondant à l'acte dans lequel le nom est trouvé -->
                    <xsl:element name="a"><xsl:attribute name="href">
                            <xsl:text>/acte/</xsl:text><xsl:value-of select="ancestor::text/@n"
                            /></xsl:attribute><xsl:value-of select="ancestor::text/@n"
                        /></xsl:element>
                    <!-- Enfin, on ajoute après cet élément soit une virgule si d'autres suivent, soit un point s'il n'y en a qu'un -->
                    <xsl:if test="position() != last()">, </xsl:if>
                    <xsl:if test="position() = last()">.</xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="index-noms-particuliers">
        <!-- On fait de même pour les noms de particuliers -->
        <xsl:for-each select="//listPerson[@type = 'particuliers']/person/persName">
            <!-- tri alphabétique -->
            <xsl:sort select="." order="ascending"/>
            <xsl:element name="p"><xsl:value-of select="."/> : <xsl:variable name="name_id">
                    <xsl:value-of select="./@xml:id"/>
                </xsl:variable>
                <xsl:for-each
                    select="ancestor::TEI//text//persName[translate(@ref, '#', '') = $name_id]">
                    <xsl:element name="a"><xsl:attribute name="href">
                            <xsl:text>/acte/</xsl:text><xsl:value-of select="ancestor::text/@n"
                            /></xsl:attribute><xsl:value-of select="ancestor::text/@n"
                        /></xsl:element>
                    <xsl:if test="position() != last()">, </xsl:if>
                    <xsl:if test="position() = last()">.</xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
