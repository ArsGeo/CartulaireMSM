<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <div>
            <xsl:call-template name="index-lieux"/>
        </div>
    </xsl:template>


    <xsl:template name="index-lieux">
        <!-- On récupère le nom de chaque lieu dans l'index -->
        <xsl:for-each select="//place/placeName/name">
            <p><xsl:value-of select="."/> : <!-- On déclare une variable correspondant à son id -->
                <xsl:variable name="place_id">
                    <xsl:value-of select="ancestor::place/@xml:id"/>
                </xsl:variable>
                <!-- On vérifie, pour chaque lieu balisé dans le texte, que la valeur de son pointeur est égale
                    à l'id du lieu renseigné dans l'index (égal à son pointeur sans le #) -->
                <xsl:for-each
                    select="ancestor::TEI//text//placeName[translate(@ref, '#', '') = $place_id]">
                    <!-- Si le test est validé, on crée un élément html <a> ayant pour attribut @href la route de la page html
                    correspondant à l'acte dans lequel le lieu est trouvé -->
                    <xsl:element name="a"><xsl:attribute name="href">
                            <xsl:text>/acte/</xsl:text><xsl:value-of select="ancestor::text/@n"
                            /></xsl:attribute><xsl:value-of select="ancestor::text/@n"
                        /></xsl:element>
                    <!-- Enfin, on ajoute après cet élément une virgule si d'autres suivent, soit un point s'il n'y en a qu'un -->
                    <xsl:if test="position() != last()">, </xsl:if>
                    <xsl:if test="position() = last()">.</xsl:if>
                </xsl:for-each>
            </p>

        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
