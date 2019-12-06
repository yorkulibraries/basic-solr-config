<?xml version="1.0" encoding="UTF-8"?>
<!-- RELS-INT
@todo make the subject of a relationship included in the name of the field-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:java="http://xml.apache.org/xalan/java"
    xmlns:foxml="info:fedora/fedora-system:def/foxml#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="rdf java">
    <xsl:variable name="single_valued_hashset_for_rels_int" select="java:java.util.HashSet.new()"/>

    <xsl:template match="foxml:datastream[@ID='RELS-INT']/foxml:datastreamVersion[last()]"
        name="index_RELS-INT">
        <xsl:param name="content"/>
        <xsl:param name="prefix">RELS_INT_</xsl:param>
        <xsl:param name="suffix">_ms</xsl:param>

        <!-- Clearing hash in case the template is ran more than once. -->
        <xsl:variable name="return_from_clear" select="java:clear($single_valued_hashset_for_rels_int)"/>

        <xsl:for-each select="$content//rdf:Description/*[@rdf:resource]">
            <!-- Prevent multiple generating multiple instances of single-valued fields
            by tracking things in a HashSet -->
            <!-- The method java.util.HashSet.add will return false when the value is
            already in the set. -->
            <xsl:choose>
            <xsl:when test="java:add($single_valued_hashset_for_rels_int, concat($prefix, local-name(), '_uri_s'))">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, local-name(), '_uri_s')"/>
                    </xsl:attribute>
                    <xsl:value-of select="@rdf:resource"/>
                </field>
                <xsl:if test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#int'">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, local-name(), '_uri_l')"/>
                        </xsl:attribute>
                        <xsl:value-of select="@rdf:resource"/>
                    </field>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, local-name(), '_uri', $suffix)"/>
                </xsl:attribute>
                <xsl:value-of select="@rdf:resource"/>
            </field>
            </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each
            select="$content//rdf:Description/*[not(@rdf:resource)][normalize-space(text())]">
            <!-- Prevent multiple generating multiple instances of single-valued fields
            by tracking things in a HashSet -->
            <!-- The method java.util.HashSet.add will return false when the value is
            already in the set. -->
            <xsl:variable name="dateValue">
              <xsl:call-template name="get_ISO8601_date">
                <xsl:with-param name="date" select="text()"/>
                <xsl:with-param name="pid" select="$PID"/>
                <xsl:with-param name="datastream" select="'RELS-INT'"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
            <xsl:when
                test="java:add($single_valued_hashset_for_rels_int, concat($prefix, local-name(), '_literal_s'))">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, local-name(), '_literal_s')"/>
                    </xsl:attribute>
                    <xsl:value-of select="text()"/>
                </field>
               <xsl:if test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#dateTime'">
                  <xsl:if test="not(normalize-space($dateValue)='')">
                    <field>
                      <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, local-name(), '_literal_dt')"/>
                      </xsl:attribute>
                      <xsl:value-of select="$dateValue"/>
                    </field>
                  </xsl:if>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <field>
                  <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, local-name(), '_literal', $suffix)"/>
                  </xsl:attribute>
                  <xsl:value-of select="text()"/>
                </field>
                <xsl:choose>
                  <xsl:when test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#dateTime'">
                    <xsl:if test="not(normalize-space($dateValue)='')">
                      <field>
                        <xsl:attribute name="name">
                          <xsl:value-of select="concat($prefix, local-name(), '_literal_mdt')"/>
                        </xsl:attribute>
                        <xsl:value-of select="$dateValue"/>
                      </field>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#int'">
                    <field>
                      <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, local-name(), '_literal_l')"/>
                      </xsl:attribute>
                      <xsl:value-of select="text()"/>
                    </field>
                  </xsl:when>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
