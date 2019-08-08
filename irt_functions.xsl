<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:subcheck="http://www.irt.de/subcheck" xmlns:tt="http://www.w3.org/ns/ttml" xmlns:tts="http://www.w3.org/ns/ttml#styling"
    xmlns:ttp="http://www.w3.org/ns/ttml#parameter" xmlns:ebuttm="urn:ebu:tt:metadata">


    <!--#########
        Parameter
        #########-->
    
    <!-- default tick rate which is used if neither tick rate nor frame rate are specified -->
    <xsl:param name="defaultTickRate" as="xs:decimal" select="1"/>    


    <!--#############
        shared values
        #############-->
    
    <xsl:variable name="regex_ttml_color" select="concat('(',
        '#[0-9a-fA-F]{6}|',
        '#[0-9a-fA-F]{8}|',
        'rgb\(( ?0*(25[0-5]|2[0-4]\d|1?\d\d?) ?,){2} ?0*(25[0-5]|2[0-4]\d|1?\d\d?) ?\)|',
        'rgba\(( ?0*(25[0-5]|2[0-4]\d|1?\d\d?) ?,){3} ?0*(25[0-5]|2[0-4]\d|1?\d\d?) ?\)|',
        'transparent|black|silver|gray|white|maroon|red|purple|fuchsia|magenta|green|lime|olive|yellow|navy|blue|teal|aqua|cyan',
        ')')"/>
    <!-- the following regex must not be used after other (parenthesized) sub-expressions, as this would break the used back-reference! -->
    <!--<xsl:variable name="regex_quoted_string">("|').*\1</xsl:variable>-->
    <xsl:variable name="regex_length_ttml1">(\+|-)?(\d*\.)?\d+(%|px|em|c)</xsl:variable>
    <xsl:variable name="regex_length_ttml2">(\+|-)?(\d*\.)?\d+(%|px|em|c|rw|rh)</xsl:variable>
    <xsl:variable name="regex_length_ttml2_non_negative">\+?(\d*\.)?\d+(%|px|em|c|rw|rh)</xsl:variable>
    <xsl:variable name="regex_absolute_profile_designator">[^:/?#]+://[^/?#]*[^?#]*(\?([^#]*))?</xsl:variable>
    <xsl:variable name="regex_relative_profile_designator">[^:?#]*(\?([^#]*))?(#(.*))?</xsl:variable>
    <xsl:variable name="regex_fragment_profile_designator">#(.*)</xsl:variable>
    <xsl:variable name="regex_profile_designator" select="concat('(', $regex_absolute_profile_designator, '|', $regex_relative_profile_designator, '|', $regex_fragment_profile_designator, ')')"/>
    <xsl:variable name="regex_position" select="concat('(',
        'center|left|right|top|bottom|', $regex_length_ttml2, '|',
        '(center|left|right|', $regex_length_ttml2, ') (center|top|bottom|', $regex_length_ttml2, ')|',
        '(center|top|bottom|', $regex_length_ttml2, ') (center|left|right|', $regex_length_ttml2, ')|',
        '(center|left|right) (top|bottom) ', $regex_length_ttml2, '|',
        '(center|top|bottom) (left|right) ', $regex_length_ttml2, '|',
        '(top|bottom) ', $regex_length_ttml2, ' (center|left|right)|',
        '(left|right) ', $regex_length_ttml2, ' (center|top|bottom)|',
        '(top|bottom) ', $regex_length_ttml2, ' (left|right) ', $regex_length_ttml2, '|',
        '(left|right) ', $regex_length_ttml2, ' (top|bottom) ', $regex_length_ttml2,
        ')')"/>


    <!--#########
        Functions
        #########-->
    
    <xsl:function name="subcheck:document_encoding" as="xs:string?">
        <xsl:param name="context" as="node()"/>
        
        <xsl:variable name="doc_encoding_regex">^[\S\s]*?encoding\s*=\s*("|')(.*?)\1[\S\s]*$</xsl:variable>
        
        <xsl:variable name="doc_raw" select="unparsed-text(document-uri($context))"/>
        
        <!-- continue, if XML declaration present -->
        <xsl:if test="starts-with($doc_raw, '&lt;?xml')">
            <xsl:variable name="doc_decl" select="concat(substring-before($doc_raw, '?&gt;'), '?&gt;')"/>
            
            <!-- continue, if document encoding present -->
            <xsl:if test="matches($doc_decl, $doc_encoding_regex)">
                <xsl:sequence select="replace($doc_decl, $doc_encoding_regex, '$2')"/>
            </xsl:if>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="subcheck:remove_ttml_color_components" as="xs:string*">
        <!-- removes all color components from a sequence and returns the resulting sequence -->
        <xsl:param name="s" as="xs:string*"/>
        <xsl:sequence select="$s[not(matches(., concat('^', $regex_ttml_color, '$')))]"/>
    </xsl:function>
    
    <xsl:function name="subcheck:string_to_units" as="xs:string*">
        <!-- splits a string at spaces into its components and returns all units -->
        <xsl:param name="s" as="xs:string?"/>
        <xsl:sequence select="
            for $token in tokenize(normalize-space($s), ' ')
            return subcheck:string_to_unit($token)
            "/>
    </xsl:function>

    <xsl:function name="subcheck:string_to_unit" as="xs:string">
        <!-- returns the unit part of a string -->
        <xsl:param name="s" as="xs:string"/>
        <xsl:sequence select="replace($s, '^[-+]?\d*\.?\d+', '')"/>
    </xsl:function>

    <xsl:function name="subcheck:string_to_amount" as="xs:decimal">
        <!-- returns the amount part of a string, as a number -->
        <xsl:param name="s" as="xs:string"/>
        <xsl:sequence select="xs:decimal(replace($s, '^([-+]?\d*\.?\d+).*$', '$1'))"/>
    </xsl:function>
    
    <xsl:function name="subcheck:time_expression_to_format" as="xs:string">
        <!-- returns the format (clock-time, offset-time) of a timeExpression (if possible); TODO: sub-frames -->
        <xsl:param name="s" as="xs:string?"/>
        <xsl:choose>
            <xsl:when test="matches(normalize-space($s), '^\d{2,}:\d\d:\d\d((:\d{2,})|(\.\d+))?$')">clock-time</xsl:when>
            <xsl:when test="matches(normalize-space($s), '^\d+(\.\d+)?([hmsft]|ms)$')">offset-time</xsl:when>
            <xsl:otherwise>unsupported-time</xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="subcheck:imsc1_signalling_present" as="xs:boolean">
        <!-- returns if the signalling for a specific IMSC1 profile is present -->
        <xsl:param name="tt" as="node()"/>
        <xsl:param name="designator" as="xs:string"/>
        <xsl:sequence select="
            (normalize-space($tt/@ttp:profile) eq $designator) or
            ($tt/tt:head/ttp:profile/@use[normalize-space(.) eq $designator]) or
            ($tt/tt:head/tt:metadata/ebuttm:documentMetadata/ebuttm:conformsToStandard[normalize-space(.) eq $designator])
            "/>
    </xsl:function>
    
    <xsl:function name="subcheck:ttml_style_chain_exists" as="xs:boolean">
        <!-- returns a string sequence of the affected styles, if a specific style is present through chained references (loop presence check, if current == checked) -->
        <xsl:param name="start" as="node()"/>
        <xsl:param name="end" as="node()"/>
        <xsl:param name="checked_styles" as="xs:string*"/>
        <xsl:sequence select="
            some $s in tokenize(normalize-space($start/@style), ' ') satisfies (
                if ($s eq $end/@xml:id)
                then true()
                else (
                    (: ignore non-existing styles :)
                    if ($start/../tt:style[@xml:id eq $s] and not($checked_styles = $s))
                    then subcheck:ttml_style_chain_exists($start/../tt:style[@xml:id eq $s], $end, ($checked_styles, $s))
                    else false()
                )
            )
            "/>
    </xsl:function>
    
    <xsl:function name="subcheck:count_used_lines" as="xs:integer">
        <!-- returns the count of lines that are used by text within a tt:p element -->
        <xsl:param name="p" as="node()"/>
        
        <xsl:if test="not($p/self::tt:p)">
            <xsl:message terminate="yes">
                This function can only be called with a tt:p element.  
            </xsl:message>
        </xsl:if>
        
        <!-- count all lines with tt:span or non-empty (normalized) text -->
        <xsl:sequence select="
            count(
                distinct-values(
                    for $x in $p//node()[self::tt:span or (self::text() and normalize-space(.) ne '')]
                    return count($x/preceding::tt:br)
                )
            )
            "/>
    </xsl:function>
    
    <xsl:function name="subcheck:timecode_valid" as="xs:boolean">
    <!-- returns true, if the timecode has valid syntax (except: sub-frames and leap seconds) -->
        <xsl:param name="tc" as="xs:string"/>
        <xsl:param name="tt" as="node()"/>
        <xsl:param name="check_dependencies" as="xs:boolean"/><!-- check if e.g. also a required ttp:frameRate value is available -->
        
        <xsl:variable name="tc_value" select="normalize-space($tc)"/>
        
        <xsl:choose>
            <!-- clock time with (or without) fraction -->
            <xsl:when test="matches($tc_value, '^\d{2,}:[0-5]\d:[0-5]\d(\.\d+)?$')">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <!-- clock time with frames (TODO: sub-frames) -->
            <xsl:when test="matches($tc_value, '^\d{2,}:[0-5]\d:[0-5]\d:\d{2,}$')">
                <xsl:variable name="frames" select="xs:decimal(replace($tc_value, '.*:(\d{2,})$', '$1'))"/>
                
                <!-- if frame rate present, ensure frames in range -->
                <xsl:sequence select="
                    if(normalize-space($tt/@ttp:frameRate) ne '')
                    then $frames lt xs:decimal($tt/@ttp:frameRate)
                    else not($check_dependencies)
                    "/>
            </xsl:when>
            <!-- offset time -->
            <xsl:when test="matches($tc_value, '^\d+(\.\d+)?([hmsft]|ms)$')">
                <xsl:choose>
                    <!-- with frames -->
                    <xsl:when test="matches($tc_value, '^\d+(\.\d+)?f$')">
                        <xsl:sequence select="not($check_dependencies) or normalize-space($tt/@ttp:frameRate) ne ''"/>
                    </xsl:when>
                    <!-- with ticks -->
                    <xsl:when test="matches($tc_value, '^\d+(\.\d+)?t$')">
                        <!--<xsl:sequence select="normalize-space($tt/@ttp:tickRate) ne ''"/>-->
                        <xsl:sequence select="true()"/>
                    </xsl:when>
                    <!-- other cases -->
                    <xsl:otherwise>
                        <xsl:sequence select="true()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="subcheck:tick_rate" as="xs:decimal">
    <!-- returns the effective tick rate that applies to all timecodes in the document (including fallback to other/default values) -->
        <xsl:param name="tt" as="node()"/>
        
        <xsl:choose>
            <xsl:when test="$tt/@ttp:tickRate">
                <xsl:sequence select="xs:decimal($tt/@ttp:tickRate)"/>
            </xsl:when>
            <xsl:when test="$tt/@ttp:frameRate">
                <xsl:sequence select="xs:decimal($tt/@ttp:frameRate)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$defaultTickRate"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="subcheck:tc2secs" as="xs:decimal">
    <!-- converts a TTML timecode (except sub-frames) into a timecode in seconds -->
        <xsl:param name="tc_raw" as="xs:string"/>
        <xsl:param name="tt" as="node()"/>
        
        <xsl:variable name="tc" select="normalize-space($tc_raw)"/>
        
        <xsl:variable name="clock_time_begin" select="'^\d{2,}:\d\d:\d\d'"/>
        <xsl:variable name="offset_time_begin" select="'^\d+(\.\d+)?'"/>
        <xsl:variable name="offset_time_end" select="'([hmsft]|ms)$'"/>
        
        <xsl:choose>
            <xsl:when test="matches($tc, $clock_time_begin)">
                <xsl:variable name="parts" select="tokenize($tc, ':|\.')"/>
                <xsl:variable name="tc_remainder" select="replace($tc, $clock_time_begin, '')"/>
                <xsl:variable name="int_seconds" select="xs:decimal($parts[1]) * 3600 + xs:decimal($parts[2]) * 60 + xs:decimal($parts[3])"/>
                
                <xsl:choose>
                    <xsl:when test="$tc_remainder eq ''">
                        <xsl:sequence select="$int_seconds"/>
                    </xsl:when>
                    <xsl:when test="matches($tc_remainder, '^\.\d+$')">
                        <!-- timecode with fraction -->
                        <xsl:sequence select="$int_seconds + xs:decimal(concat('0.', $parts[4]))"/>
                    </xsl:when>
                    <xsl:when test="matches($tc_remainder, '^:\d{2,}$')">
                        <!-- timecode with frames -->
                        <xsl:sequence select="$int_seconds + xs:decimal($parts[4]) div xs:decimal($tt/@ttp:frameRate)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The value '<xsl:value-of select="$tc_raw"/>' is not a valid timecode.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="matches($tc, concat($offset_time_begin, $offset_time_end))">
                <xsl:variable name="tc_value" select="replace($tc, $offset_time_end, '')"/>
                <xsl:variable name="tc_unit" select="replace($tc, $offset_time_begin, '')"/>
                <xsl:choose>
                    <xsl:when test="$tc_unit eq 'h'"><xsl:sequence select="xs:decimal($tc_value) * 3600"/></xsl:when>
                    <xsl:when test="$tc_unit eq 'm'"><xsl:sequence select="xs:decimal($tc_value) * 60"/></xsl:when>
                    <xsl:when test="$tc_unit eq 's'"><xsl:sequence select="xs:decimal($tc_value)"/></xsl:when>
                    <xsl:when test="$tc_unit eq 'ms'"><xsl:sequence select="xs:decimal($tc_value) * 0.001"/></xsl:when>
                    <xsl:when test="$tc_unit eq 'f'"><xsl:sequence select="xs:decimal($tc_value) div xs:decimal($tt/@ttp:frameRate)"/></xsl:when>
                    <xsl:when test="$tc_unit eq 't'"><xsl:sequence select="xs:decimal($tc_value) div subcheck:tick_rate($tt)"/></xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">
                            The value '<xsl:value-of select="$tc_raw"/>' is not a valid timecode.
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    The value '<xsl:value-of select="$tc_raw"/>' is not a valid timecode.
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:function>
    
    <xsl:function name="subcheck:tc2frames" as="xs:decimal?">
    <!-- converts a TTML timecode (except sub-frames) into a timecode in frames (empty result, if not a frames timecode) -->
        <xsl:param name="tc_raw" as="xs:string"/>
        <xsl:param name="tt" as="node()"/>
        
        <xsl:variable name="tc" select="normalize-space($tc_raw)"/>
        
        <xsl:choose>
            <!-- handle clock time with frames (or without fraction) -->
            <xsl:when test="matches($tc, '^\d{2,}:\d\d:\d\d(:\d{2,})?$') and $tt/@ttp:frameRate">
                <xsl:variable name="parts" select="tokenize($tc, ':')"/>
                <xsl:variable name="int_seconds" select="xs:decimal($parts[1]) * 3600 + xs:decimal($parts[2]) * 60 + xs:decimal($parts[3])"/>
                <xsl:variable name="fraction" select="if (count($parts) eq 4) then xs:decimal($parts[4]) else 0"/>
                <xsl:sequence select="$int_seconds * xs:decimal($tt/@ttp:frameRate) + $fraction"/>
            </xsl:when>
            <!-- handle offset time with frames -->
            <xsl:when test="matches($tc, '^\d+(\.\d+)?f$')">
                <xsl:sequence select="xs:decimal(replace($tc, 'f$', ''))"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="subcheck:tc_diff" as="xs:decimal">
    <!--
        Returns the result of one ore more subtrahends subtracted from a minuend (either in seconds or in frames)
        If all timecodes refer to frames, the frames domain is used to prevent a result with misleading decimal places due to imprecision
    -->
        <xsl:param name="min" as="xs:string"/>
        <xsl:param name="subtr" as="xs:string+"/>
        <xsl:param name="tt" as="node()"/>
        <xsl:param name="return_frames" as="xs:boolean"/><!-- if true, the result is in frames instead of seconds -->

        <!-- try to convert all values into frames -->
        <xsl:variable name="min_f" select="subcheck:tc2frames($min, $tt)"/>
        <xsl:variable name="subtr_f" select="for $tc in $subtr return subcheck:tc2frames($tc, $tt)"/>
        
        <xsl:choose>
            <!-- do calculation in frames domain -->
            <xsl:when test="$tt/@ttp:frameRate and exists($min_f) and count($subtr) eq count($subtr_f)">
                <xsl:variable name="raw_result" select="$min_f - sum($subtr_f)"/>
                
                <!-- convert result to seconds, if needed -->
                <xsl:sequence select="$raw_result div (if (not($return_frames)) then xs:decimal($tt/@ttp:frameRate) else 1)"/>
            </xsl:when>
            <!-- do calculation in seconds domain -->
            <xsl:otherwise>
                <xsl:variable name="min_s" select="subcheck:tc2secs($min, $tt)"/>
                <xsl:variable name="subtr_s" select="for $tc in $subtr return subcheck:tc2secs($tc, $tt)"/>
                <xsl:variable name="raw_result" select="$min_s - sum($subtr_s)"/>
                
                <!-- convert result to frames, if needed -->
                <xsl:sequence select="$raw_result * (if ($return_frames) then xs:decimal($tt/@ttp:frameRate) else 1)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="subcheck:subtitle_duration_secs" as="xs:decimal?">
    <!-- returns the duration of a subtitle (in form of a tt:p element) in seconds, or otherwise (on missing prerequisites) an empty sequence -->
        <xsl:param name="p" as="node()"/>
        
        <xsl:choose>
            <xsl:when test="$p/@begin and subcheck:timecode_valid($p/@begin, root($p)/tt:tt, true()) and $p/@end and subcheck:timecode_valid($p/@end, root($p)/tt:tt, true())">
                <xsl:sequence select="subcheck:tc_diff($p/@end, $p/@begin, root($p)/tt:tt, false())"/>
            </xsl:when>
            <xsl:when test="$p/@dur and subcheck:timecode_valid($p/@dur, root($p)/tt:tt, true())">
                <xsl:sequence select="subcheck:tc2secs($p/@dur, root($p)/tt:tt)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="subcheck:subtitle_gap_frames" as="xs:decimal?">
    <!-- returns the duration of the gap between two adjacent subtitles (from which the first one has to be specified) in frames, or otherwise (on missing prerequisites) an empty sequence  -->
        <xsl:param name="p" as="node()"/>
        <xsl:variable name="p2" select="$p/following-sibling::tt:p[1]"/>
        
        <xsl:choose>
            <xsl:when test="$p/@end and subcheck:timecode_valid($p/@end, root($p)/tt:tt, true()) and $p2/@begin and subcheck:timecode_valid($p2/@begin, root($p)/tt:tt, true())">
                <xsl:sequence select="subcheck:tc_diff($p2/@begin, $p/@end, root($p)/tt:tt, true())"/>
            </xsl:when>
            <xsl:when test="$p/@begin and subcheck:timecode_valid($p/@begin, root($p)/tt:tt, true()) and $p/@dur and subcheck:timecode_valid($p/@dur, root($p)/tt:tt, true()) and $p2/@begin and subcheck:timecode_valid($p2/@begin, root($p)/tt:tt, true())">
                <xsl:sequence select="subcheck:tc_diff($p2/@begin, ($p/@dur, $p/@begin), root($p)/tt:tt, true())"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="subcheck:subtitle_begin_delta_secs" as="xs:decimal?">
        <!-- returns the difference between the begin timecodes of two adjacent subtitles (from which the first one has to be specified) in seconds, or otherwise (on missing prerequisites) an empty sequence  -->
        <xsl:param name="p" as="node()"/>
        <xsl:variable name="p2" select="$p/following-sibling::tt:p[1]"/>
        
        <xsl:if test="$p/@begin and subcheck:timecode_valid($p/@begin, root($p)/tt:tt, true()) and $p2/@begin and subcheck:timecode_valid($p2/@begin, root($p)/tt:tt, true())">
            <xsl:sequence select="subcheck:tc_diff($p2/@begin, $p/@begin, root($p)/tt:tt, false())"/>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="subcheck:get_tts_ruby" as="xs:string">
        <xsl:param name="n" as="node()"/>
        <xsl:param name="everywhere" as="xs:boolean"/><!-- don't restrict search to elements on which the attribute applies -->
        <xsl:sequence select="subcheck:get_style_property($n, xs:QName('tts:ruby'), false(), if($everywhere) then () else xs:QName('tt:span'), 'none', true())"/>
    </xsl:function>

    <xsl:function name="subcheck:get_style_property" as="xs:string">
        <!-- returns the value of a specific style property that applies to an element, if available - otherwise, a specified default value is returned -->
        <xsl:param name="n" as="node()"/>
        <xsl:param name="property" as="xs:QName"/>
        <xsl:param name="inherited" as="xs:boolean"/><!-- this specifies, whether the property can be inherited -->
        <xsl:param name="specified_on" as="xs:QName*"/><!-- specifies on which elements a property can be specified on; if EMPTY, the property can be specified on any element -->
        <xsl:param name="default" as="xs:string"/><!-- property default value -->
        <xsl:param name="use_initial" as="xs:boolean"/><!-- this specifies, whether the tt:initial property value (available since TTML2) shall override the property's default value -->
        
        <!-- determine initial value (use last one, if multiple present) -->
        <xsl:variable name="initial_value" select="root($n)/tt:tt/tt:head/tt:styling/tt:initial/attribute::*[node-name(.) eq $property][last()]"/>
        
        <!-- return final property value -->
        <xsl:variable name="property_values" select="$default, if($use_initial) then $initial_value else (), subcheck:get_style_property_values($n, $property, $inherited, $specified_on, '', ())"/>
        <xsl:sequence select="$property_values[last()]"/>
        
        <!-- ##### DEBUG ##### -->
        <!--<xsl:message><xsl:value-of select="concat('Values (', count($property_values) , '): ''', string-join($property_values, ''', '''), '''')"/></xsl:message>-->
    </xsl:function>
    
    <xsl:function name="subcheck:get_style_property_values" as="xs:string*">
        <!-- returns the values of a specific style property that apply to an element - in order of significance, from the least to the most significant one (except: animation styling) -->
        <xsl:param name="n" as="node()"/>
        <xsl:param name="property" as="xs:QName"/>
        <xsl:param name="inherited" as="xs:boolean"/>
        <xsl:param name="specified_on" as="xs:QName*"/>
        <xsl:param name="old_region" as="xs:string"/>
        <xsl:param name="seen_styles" as="xs:string*"/>
        
        <!-- ##### DEBUG ##### -->
        <!--<xsl:message>Node name: <xsl:value-of select="node-name($n)"/><xsl:if test="node-name($n) = (xs:QName('tt:style'), xs:QName('tt:region'))">, ID: '<xsl:value-of select="$n/@xml:id"/>'</xsl:if></xsl:message>-->
        
        <!-- derive property values only if styling allowed on node (skipping already seen styles) -->
        <xsl:if test="$n/self::tt:style[not($seen_styles = @xml:id)] or $n/self::tt:region or $n/self::tt:body or $n/self::tt:div or $n/self::tt:p or $n/self::tt:span or $n/self::tt:br">
            <!-- set region only once during recursion -->
            <xsl:variable name="region" select="
                if($old_region ne '')
                then $old_region
                else normalize-space($n/@region)
                "/>
            
            <!-- update seen styles -->
            <xsl:variable name="seen_styles_new" select="
                $seen_styles, if($n/self::tt:style) then $n/@xml:id else ()
                "/>

            <xsl:variable name="specified_on_fulfilled" select="empty($specified_on) or $specified_on = node-name($n)"/>
            
            <!-- get values: implicit inheritance (if applicable; skipping non-existing regions) -->
            <!-- if on tt:body, proceed towards the applicable tt:region, to emulate ISD behaviour -->
            <!-- consider inheritance, except: on an element, where the property can be specified on and if property cannot be inherited -->
            <xsl:variable name="inherited_styling" select="
                if(not($specified_on_fulfilled and not($inherited)))
                then
                    if(not($n/self::tt:style) and not($n/self::tt:region) and not($n/self::tt:body))
                    then subcheck:get_style_property_values($n/.., $property, $inherited, $specified_on, $region, $seen_styles_new)
                    else
                        if($n/self::tt:body and $region ne '')
                        then
                            for $r in root($n)/tt:tt/tt:head/tt:layout/tt:region[@xml:id eq $region]
                            return subcheck:get_style_property_values($r, $property, $inherited, $specified_on, $region, $seen_styles_new)
                        else ()
                else ()
                ">
            </xsl:variable>
            
            <!-- get values: referential and chained referential styling (always allowed on tt:style; skipping non-existing styles) -->
            <xsl:variable name="referential_styling" select="
                if($n/self::tt:style or $specified_on_fulfilled)
                then
                    for $style_id in tokenize(normalize-space($n/@style), ' ')
                    return
                        for $style in root($n)/tt:tt/tt:head/tt:styling/tt:style[@xml:id eq $style_id]
                        return subcheck:get_style_property_values($style, $property, $inherited, $specified_on, $region, $seen_styles_new)
                else ()
                "/>
            
            <!-- get values: nested styling (layout only) -->
            <xsl:variable name="nested_styling" select="
                if($n/self::tt:region and $specified_on_fulfilled)
                then $n/tt:style/attribute::*[node-name(.) eq $property]
                else ()
                "/>
            
            <!-- get values: inline styling (always allowed on tt:style) -->
            <xsl:variable name="inline_styling" select="
                if($n/self::tt:style or $specified_on_fulfilled)
                then $n/attribute::*[node-name(.) eq $property]
                else ()
                "/>
            
            <!-- return collected values in significance order -->
            <xsl:sequence select="$inherited_styling, $referential_styling, $nested_styling, $inline_styling"/>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="subcheck:remove_unique_occurence" as="xs:string*">
        <!-- removes a regex occurence, if it matches exactly once in all parts -->
        <xsl:param name="s_orig" as="xs:string*"/>
        <xsl:param name="regex" as="xs:string"/>
        
        <xsl:variable name="s" select="for $x in $s_orig return normalize-space($x)"/>
        
        <!-- for every match, the token count increments, so decrement it to get match count (additional leading/succeeding space handles matches at begin/end) -->
        <xsl:variable name="matches" select="sum(for $x in $s return (count(tokenize(concat(' ', $x, ' '), $regex)) - 1))"/>
        
        <xsl:choose>
            <xsl:when test="$matches eq 1">
                <!-- tokenize to prevent matching of e.g. "sesame white open" due to the order of token removal when multiple steps are used, instead of just remove match -->
                <xsl:sequence select="for $x in $s return tokenize($x, $regex)[. ne '']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$s"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="subcheck:get_reading_speeds" as="xs:double*">
        <!-- returns the reading speed (characters/second) for all contained tt:p elements as a sequence -->
        <xsl:param name="tt" as="node()"/>
        
        <xsl:for-each select="$tt/tt:body//tt:p">
            <xsl:sequence select="subcheck:get_reading_speed(.)"/>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="subcheck:get_reading_speed" as="xs:double?">
        <!-- returns the reading speed (characters/second) for a tt:p element, or otherwise (on missing prerequisites) an empty sequence -->
        <xsl:param name="p" as="node()"/>
        
        <!-- retrieve subtitle duration -->
        <xsl:variable name="secs" select="subcheck:subtitle_duration_secs($p)"/>
        
        <!-- continue only if duration available -->
        <xsl:if test="exists($secs)">
            <!-- retrieve text character count -->
            <xsl:variable name="chars" select="
                sum(
                    for $t in $p//text()
                    return string-length(normalize-space($t))
                )
                "/>
            
            <!-- return computed result -->
            <xsl:sequence select="$chars div $secs"/>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="subcheck:checkNetflixGlyphs">
        <xsl:param name="testString" as="xs:string"/>
        <xsl:variable name="testStringCodepoints" select="string-to-codepoints($testString)"/>        
        <xsl:variable name="allowedGlyphs" select="32 to 126, 160 to 311, 313 to 328, 330 to 382, 402 to 403, 416 to 417, 431 to 432, 450, 461 to 462, 464 to 466, 468, 470, 472, 474, 476, 504 to 511, 536 to 539, 592 to 604, 606 to 609, 612 to 616, 618, 620 to 627, 629, 633 to 635, 637 to 638, 641 to 644, 648 to 654, 656 to 658, 660 to 661, 664, 669, 673 to 674, 710 to 713, 716, 720 to 721, 728 to 734, 741 to 745, 768 to 772, 774, 776 to 777, 779 to 780, 783, 792 to 794, 796 to 800, 803 to 805, 809 to 810, 812, 815 to 816, 820, 825 to 829, 865, 894, 900 to 906, 908, 910 to 929, 931 to 974, 1024 to 1119, 1168 to 1171, 1178 to 1179, 1186 to 1187, 1198 to 1203, 1206 to 1207, 1210 to 1211, 1240 to 1241, 1250 to 1251, 1256 to 1257, 1262 to 1263, 1329 to 1366, 1369 to 1375, 1377 to 1415, 1417 to 1418, 1456 to 1465, 1467 to 1471, 1473 to 1475, 1488 to 1514, 1520 to 1524, 1547 to 1548, 1563, 1567, 1569 to 1594, 1600 to 1618, 1620, 1625, 1632 to 1645, 1648, 1657, 1660, 1662, 1665, 1669 to 1670, 1672 to 1673, 1681 to 1686, 1688, 1690, 1696, 1700, 1705, 1707, 1709, 1711, 1717 to 1718, 1722, 1724 to 1726, 1728 to 1731, 1734 to 1737, 1739 to 1749, 1776 to 1785, 1890, 2305 to 2307, 2309 to 2361, 2364 to 2381, 2384, 2392 to 2416, 2433 to 2435, 2437 to 2444, 2447 to 2448, 2451 to 2472, 2474 to 2480, 2482, 2486 to 2489, 2492 to 2500, 2503 to 2504, 2507 to 2510, 2519, 2524 to 2525, 2527 to 2531, 2534 to 2554, 2561 to 2563, 2565 to 2570, 2575 to 2576, 2579 to 2600, 2602 to 2608, 2610 to 2611, 2613 to 2614, 2616 to 2617, 2620, 2622 to 2626, 2631 to 2632, 2635 to 2637, 2641, 2649 to 2652, 2654, 2662 to 2676, 2689 to 2691, 2693 to 2701, 2703 to 2705, 2707 to 2728, 2730 to 2736, 2738 to 2739, 2741 to 2745, 2748 to 2757, 2759 to 2761, 2763 to 2765, 2768, 2784 to 2787, 2790 to 2799, 2801, 2817 to 2819, 2821 to 2828, 2831 to 2832, 2835 to 2856, 2858 to 2864, 2866 to 2867, 2869 to 2873, 2876 to 2884, 2887 to 2888, 2891 to 2893, 2902 to 2903, 2908 to 2909, 2911 to 2915, 2918 to 2929, 2946 to 2947, 2949 to 2954, 2958 to 2960, 2962 to 2965, 2969 to 2970, 2972, 2974 to 2975, 2979 to 2980, 2984 to 2986, 2990 to 3001, 3006 to 3010, 3014 to 3016, 3018 to 3021, 3024, 3031, 3046 to 3066, 3073 to 3075, 3077 to 3084, 3086 to 3088, 3090 to 3112, 3114 to 3123, 3125 to 3129, 3133 to 3140, 3142 to 3144, 3146 to 3149, 3157 to 3158, 3160 to 3161, 3168 to 3171, 3174 to 3183, 3192 to 3199, 3202 to 3203, 3205 to 3212, 3214 to 3216, 3218 to 3240, 3242 to 3251, 3253 to 3257, 3260 to 3268, 3270 to 3272, 3274 to 3277, 3285 to 3286, 3294, 3296 to 3299, 3302 to 3311, 3330 to 3331, 3333 to 3340, 3342 to 3344, 3346 to 3368, 3370 to 3385, 3389 to 3396, 3398 to 3400, 3402 to 3405, 3415, 3424 to 3427, 3430 to 3445, 3449 to 3455, 3585 to 3642, 3647 to 3675, 4304 to 4348, 4352 to 4606, 7742 to 7743, 7808 to 7813, 7840 to 7929, 8048 to 8051, 8208, 8211 to 8222, 8224 to 8226, 8229 to 8230, 8240, 8242 to 8243, 8245, 8249 to 8255, 8258, 8260, 8263 to 8265, 8273, 8304, 8308 to 8334, 8353, 8358, 8361 to 8366, 8369, 8372, 8377, 8451, 8453, 8457, 8463, 8467, 8470 to 8471, 8481 to 8482, 8486 to 8487, 8491, 8494, 8501, 8531 to 8533, 8539 to 8542, 8544 to 8555, 8560 to 8571, 8592 to 8601, 8616, 8632 to 8633, 8644, 8658, 8660, 8678 to 8681, 8704, 8706 to 8707, 8709 to 8713, 8715, 8719, 8721 to 8723, 8725, 8729 to 8730, 8733 to 8736, 8741 to 8748, 8750, 8756 to 8757, 8765, 8771, 8773, 8776, 8786, 8800 to 8802, 8804 to 8807, 8810 to 8811, 8822 to 8823, 8834 to 8839, 8842 to 8843, 8853 to 8855, 8869, 8895, 8922 to 8923, 8962, 8965 to 8966, 8976, 8978, 8984, 9150 to 9164, 9166, 9251, 9312 to 9331, 9424 to 9449, 9451 to 9470, 9472 to 9475, 9484, 9487 to 9488, 9491 to 9492, 9495 to 9496, 9499 to 9501, 9504, 9507 to 9509, 9512, 9515 to 9516, 9519 to 9520, 9523 to 9524, 9527 to 9528, 9531 to 9532, 9535, 9538, 9547, 9608, 9632 to 9633, 9642 to 9643, 9649 to 9651, 9654 to 9655, 9658, 9660 to 9661, 9664 to 9665, 9668, 9670 to 9675, 9678 to 9683, 9688 to 9689, 9698 to 9702, 9711, 9728 to 9731, 9733 to 9734, 9737, 9742 to 9743, 9750 to 9751, 9756, 9758, 9786 to 9789, 9792 to 9794, 9824 to 9839, 10003, 10070, 10102 to 10111, 10548 to 10549, 10687, 10746 to 10747, 12288 to 12351, 12353 to 12438, 12441 to 12543, 12549 to 12589, 12593 to 12686, 12784 to 12830, 12832 to 13054, 13059, 13069, 13076, 13080, 13090 to 13091, 13094 to 13095, 13099, 13110, 13115, 13129 to 13130, 13133, 13137, 13143, 13179 to 13182, 13184 to 13188, 13192 to 13259, 13261 to 13267, 13269 to 13270, 13272, 13275 to 13277, 13314, 13318, 13356, 13358, 13365, 13376, 13386, 13388, 13412, 13416, 13418, 13427, 13434, 13437 to 13438, 13458 to 13459, 13462, 13477, 13487, 13493, 13500, 13505, 13511 to 13512, 13531, 13535, 13540, 13563, 13574, 13599, 13630, 13649, 13651, 13657, 13661 to 13662, 13665, 13667, 13677 to 13678, 13680, 13682, 13687 to 13688, 13700, 13719 to 13720, 13729, 13733 to 13734, 13736, 13741, 13759, 13761, 13765, 13767, 13770, 13774, 13778, 13782, 13786 to 13787, 13789, 13809 to 13812, 13819, 13822, 13829, 13833, 13848, 13850, 13859, 13861, 13869, 13877, 13881, 13886, 13895 to 13898, 13902, 13919, 13921, 13946, 13953, 13969, 13974, 13977 to 13978, 13989, 13994, 13996, 14000 to 14001, 14005, 14009, 14012, 14017, 14019 to 14021, 14023 to 14024, 14031, 14035 to 14036, 14038, 14045, 14049 to 14050, 14053 to 14054, 14069, 14081, 14083, 14088, 14090, 14093, 14108, 14114 to 14115, 14117, 14124 to 14125, 14128, 14130 to 14131, 14138, 14144, 14147, 14177 to 14178, 14187 to 14188, 14191, 14197, 14221, 14231, 14240, 14265, 14270, 14273, 14294, 14306, 14312, 14322, 14324, 14328, 14331, 14333, 14336, 14351, 14361, 14368, 14381, 14383, 14390, 14392, 14400, 14428, 14433, 14435, 14496, 14531, 14540, 14545, 14548, 14586, 14600, 14612, 14615, 14618, 14631, 14642, 14655, 14669, 14691, 14703, 14712, 14720, 14729 to 14730, 14738, 14745, 14747, 14753, 14756, 14776, 14812, 14818, 14821, 14828, 14840, 14843, 14846, 14849, 14851, 14854, 14871 to 14872, 14889 to 14890, 14900, 14923, 14930, 14935, 14940, 14942, 14950 to 14951, 14958, 14963, 14999, 15019, 15037, 15062 to 15063, 15070, 15072, 15082, 15088, 15090, 15099, 15118, 15129 to 15130, 15132, 15138, 15147, 15161, 15170, 15192, 15200, 15213, 15217 to 15218, 15223, 15227 to 15228, 15232, 15239 to 15240, 15245, 15253 to 15254, 15257, 15265, 15268, 15286, 15292, 15294, 15298 to 15300, 15309, 15319, 15325, 15340, 15344, 15346 to 15348, 15373, 15375, 15377, 15381, 15384, 15398, 15444, 15499, 15555, 15563, 15565, 15569 to 15570, 15574, 15580, 15595, 15599, 15633 to 15635, 15645 to 15646, 15666, 15675, 15686, 15692, 15694, 15697, 15711, 15714, 15716, 15721 to 15722, 15727, 15733, 15741, 15749, 15752, 15754, 15759, 15761, 15770, 15781, 15789, 15796, 15807 to 15808, 15814 to 15815, 15817, 15820 to 15821, 15827 to 15828, 15835, 15847 to 15848, 15851, 15859 to 15860, 15863, 15868 to 15869, 15877 to 15878, 15935 to 15936, 15939, 15944, 15957, 15968, 15974, 15976, 15988, 16003, 16020, 16040 to 16042, 16045, 16049, 16056, 16063, 16066, 16071, 16074, 16076, 16080 to 16081, 16086 to 16087, 16090 to 16091, 16094, 16097 to 16098, 16103, 16105, 16107, 16112, 16115 to 16116, 16122, 16124, 16127 to 16128, 16132, 16134 to 16136, 16142, 16211, 16215 to 16217, 16227, 16242, 16245, 16247, 16252, 16275, 16302, 16320, 16328 to 16329, 16343, 16348, 16357, 16365, 16377 to 16378, 16388, 16393, 16413, 16441, 16453, 16467, 16471 to 16472, 16482, 16485, 16490, 16495, 16497, 16531, 16552, 16571, 16575, 16584, 16600, 16607, 16632, 16634, 16642 to 16645, 16649, 16654, 16690, 16712, 16719, 16739, 16743, 16748, 16750, 16764, 16767, 16784, 16818, 16820, 16831, 16836, 16842, 16847, 16859, 16870, 16877 to 16879, 16883, 16889, 16903, 16910, 16913, 16931, 16960, 16992, 16996, 17002, 17014, 17018, 17036, 17044, 17058, 17077, 17081, 17084, 17094, 17110, 17117, 17140, 17147 to 17148, 17154, 17195, 17219, 17262, 17303, 17306, 17338, 17345, 17369, 17375, 17389 to 17390, 17392, 17394, 17409 to 17410, 17416, 17427, 17431, 17436, 17442, 17445, 17453, 17491, 17499, 17526, 17530, 17551, 17553, 17567 to 17568, 17570, 17584, 17587, 17591, 17597 to 17598, 17600, 17603, 17605, 17614, 17620, 17629 to 17631, 17636, 17641 to 17644, 17652, 17667 to 17668, 17672 to 17673, 17675, 17677, 17686, 17691, 17693, 17701, 17703, 17710, 17715, 17718, 17723, 17725, 17727, 17731, 17745 to 17746, 17749, 17752, 17756, 17761 to 17762, 17770 to 17771, 17773, 17783 to 17784, 17797, 17821, 17830, 17843, 17848, 17882, 17893, 17897 to 17898, 17923, 17926, 17935, 17941, 17943, 17985, 18011, 18021, 18042, 18048, 18081, 18095, 18107, 18127 to 18128, 18165, 18167, 18188, 18195, 18200, 18230, 18244, 18254 to 18255, 18276, 18300, 18328, 18342, 18358, 18389, 18413, 18420, 18429, 18432, 18443, 18454, 18487, 18500, 18510, 18525, 18545, 18587, 18605 to 18606, 18613, 18640, 18653, 18669, 18675, 18682, 18694, 18705, 18718, 18725, 18730, 18733, 18741, 18748, 18750, 18757, 18769, 18771, 18789, 18794, 18802, 18825, 18849, 18855, 18864, 18911, 18917, 18919, 18938, 18948, 18959, 18973, 18980, 18985, 18997, 19094, 19108, 19124, 19128, 19132, 19153, 19172, 19199, 19216, 19225, 19232, 19244, 19255, 19259, 19311 to 19312, 19314, 19323, 19326, 19342, 19344, 19347, 19350 to 19351, 19357, 19389 to 19390, 19392, 19394, 19402, 19410, 19432, 19460, 19463, 19470, 19479, 19488, 19506, 19515, 19518, 19520, 19527, 19543, 19547, 19565, 19575, 19579, 19581, 19585, 19589, 19620, 19630, 19632, 19639, 19652, 19661, 19665, 19681 to 19682, 19693, 19719, 19721, 19728, 19764, 19830 to 19831, 19849, 19857, 19868, 19968 to 40883, 44032 to 55203, 63773, 63784 to 63785, 63798, 63856, 63952, 63964, 64015 to 64017, 64019 to 64022, 64025 to 64027, 64031 to 64034, 64036, 64038, 64048 to 64106, 64256 to 64260, 65093 to 65094, 65281 to 65470, 65474 to 65479, 65482 to 65487, 65490 to 65495, 65498 to 65500, 65504 to 65510, 65512 to 65518, 131083, 131105, 131134, 131142, 131150, 131176, 131206 to 131207, 131209 to 131210, 131220, 131234, 131236, 131274 to 131277, 131281, 131310, 131340, 131342, 131352, 131490, 131492, 131497, 131499, 131521, 131540, 131570, 131588, 131596, 131603 to 131604, 131641, 131675, 131700 to 131701, 131737, 131742, 131744, 131767, 131775 to 131776, 131813, 131850, 131877, 131883, 131905, 131909 to 131911, 131953, 131966 to 131969, 132000, 132007, 132021, 132041, 132043, 132085, 132089, 132092, 132115 to 132116, 132127, 132170, 132197, 132231, 132238, 132241 to 132242, 132259, 132311, 132348, 132350, 132361, 132423, 132494, 132517, 132531, 132547, 132554, 132560, 132565 to 132566, 132575 to 132576, 132587, 132625, 132629, 132633 to 132634, 132648, 132656, 132694, 132726, 132878, 132913, 132943, 132985, 133127, 133164, 133178, 133235, 133305, 133333, 133398, 133411, 133460, 133497, 133500, 133533, 133607, 133649, 133712, 133743, 133812, 133826, 133837, 133843, 133901, 133917, 134031, 134047, 134056 to 134057, 134079, 134086, 134091, 134114, 134123, 134139, 134143, 134155, 134157, 134176, 134196, 134202 to 134203, 134209 to 134211, 134227, 134245, 134263 to 134264, 134268, 134285, 134294, 134300, 134325, 134328, 134351, 134355 to 134358, 134365, 134381, 134399, 134421, 134440, 134449 to 134450, 134469 to 134473, 134476 to 134478, 134511, 134513, 134516, 134524, 134526 to 134527, 134550, 134556, 134567, 134578, 134600, 134625, 134660, 134665 to 134666, 134669 to 134673, 134678, 134685, 134732, 134756, 134765, 134771, 134773 to 134779, 134796, 134805 to 134806, 134808, 134813, 134818, 134826 to 134828, 134838, 134871 to 134872, 134877, 134904 to 134907, 134941, 134950, 134957 to 134958, 134960 to 134961, 134971, 134988, 135007, 135012, 135053, 135056, 135085, 135092 to 135094, 135100, 135135, 135146 to 135149, 135188, 135197 to 135198, 135247, 135260, 135279, 135285 to 135288, 135291, 135304, 135318, 135325, 135348, 135359 to 135361, 135367 to 135369, 135375, 135379, 135396, 135412 to 135414, 135471, 135483, 135485, 135493, 135496, 135503, 135552, 135559, 135641, 135681, 135740 to 135741, 135759, 135765, 135796, 135803 to 135804, 135848 to 135849, 135856, 135895, 135907 to 135908, 135933 to 135934, 135938 to 135941, 135963, 135990, 135994, 136004, 136053 to 136054, 136078, 136088, 136092, 136132 to 136134, 136173, 136190, 136211, 136214, 136228, 136255, 136274, 136276 to 136277, 136301 to 136302, 136330, 136343, 136374, 136424, 136445, 136567, 136578, 136598, 136663, 136714, 136723, 136729, 136766, 136775, 136801, 136850, 136884, 136888, 136890, 136896 to 136898, 136915, 136917, 136927, 136934 to 136936, 136954 to 136956, 136958, 136966, 136973, 136976, 136998, 137018 to 137020, 137026, 137047, 137068 to 137073, 137075 to 137076, 137131, 137136 to 137141, 137155, 137159, 137177 to 137180, 137183, 137199, 137205 to 137206, 137208 to 137212, 137248, 137256 to 137258, 137261, 137273 to 137275, 137280, 137285, 137298, 137310, 137313 to 137316, 137335, 137339, 137347 to 137349, 137374 to 137378, 137405 to 137407, 137425, 137430 to 137433, 137466, 137475 to 137477, 137488 to 137490, 137493, 137500, 137506, 137511, 137531, 137540, 137560, 137578, 137596, 137600, 137603, 137608, 137622, 137667, 137691, 137715, 137773, 137780, 137797, 137803, 137827, 138052, 138177 to 138178, 138282, 138326, 138352, 138402, 138405, 138412, 138541, 138565 to 138566, 138590, 138594, 138616, 138640, 138642, 138652, 138657, 138678 to 138679, 138682, 138698, 138705, 138720, 138731, 138745, 138780, 138787, 138803 to 138804, 138807, 138813, 138889, 138916, 138920, 138952, 138965, 139023, 139029, 139038, 139114, 139126, 139166, 139169, 139240, 139258, 139333, 139337, 139390, 139418, 139463, 139516, 139562, 139611, 139635, 139642 to 139643, 139681, 139713, 139715, 139784, 139800, 139900, 140062, 140065, 140069, 140205, 140221, 140240, 140247, 140282, 140389, 140401, 140427, 140433, 140464, 140525, 140563, 140571, 140592, 140628, 140685, 140719, 140734, 140827 to 140828, 140843, 140904, 140922, 140950, 140952, 141043 to 141046, 141074, 141076, 141083, 141087, 141098, 141173, 141185, 141206, 141236 to 141237, 141261, 141315, 141403, 141407 to 141408, 141425, 141483, 141485, 141505, 141559, 141606, 141625, 141647, 141671, 141675, 141696, 141711, 141715, 141926, 142008, 142031, 142037, 142054, 142056, 142094, 142114, 142143, 142147, 142150, 142159 to 142160, 142186, 142246, 142282, 142286, 142365, 142372, 142374 to 142375, 142392, 142412, 142417, 142421, 142434, 142472, 142491, 142497, 142505, 142514, 142519, 142530, 142534, 142537, 142599 to 142600, 142610, 142660, 142668, 142695, 142733, 142741, 142752, 142755 to 142756, 142775, 142817, 142830, 142861, 142902, 142914, 142968, 142987, 143027, 143087, 143220, 143308, 143331, 143411, 143428, 143435, 143462, 143485 to 143486, 143502, 143543, 143548, 143578, 143619, 143677, 143741, 143746, 143780 to 143781, 143795, 143798, 143811 to 143812, 143816 to 143817, 143861, 143863 to 143865, 143887, 143909, 143919, 143921 to 143924, 143958, 143970, 144001, 144009 to 144010, 144043 to 144045, 144082, 144096 to 144097, 144128, 144138, 144159, 144242, 144308, 144332, 144336, 144338 to 144339, 144341, 144346, 144350 to 144351, 144356, 144358, 144372 to 144373, 144377 to 144378, 144382, 144384, 144447, 144458 to 144459, 144464 to 144465, 144485, 144495, 144498, 144612 to 144613, 144665, 144688, 144721, 144730, 144743, 144788 to 144789, 144793, 144796, 144836, 144845 to 144847, 144883, 144896, 144919, 144922, 144952 to 144954, 144956, 144960, 144967, 144985, 144991, 145015, 145062, 145069, 145082, 145119, 145134, 145155, 145164, 145174, 145180, 145184, 145197, 145199, 145215, 145251 to 145252, 145254, 145281, 145314, 145340, 145346, 145365 to 145367, 145383, 145407, 145444, 145466, 145469, 145858, 146072, 146087, 146139, 146158, 146170, 146202, 146266, 146531, 146559, 146585 to 146587, 146613, 146615, 146631 to 146633, 146684 to 146688, 146702, 146752, 146779, 146814, 146831, 146870 to 146877, 146899, 146915, 146936 to 146938, 146950, 146961, 146988 to 146993, 147001, 147080 to 147083, 147129, 147135, 147159, 147191 to 147196, 147253, 147265, 147274, 147297, 147326 to 147330, 147343, 147380, 147383, 147392, 147397, 147435 to 147440, 147473, 147513 to 147517, 147543, 147589, 147595 to 147597, 147601, 147606, 147657, 147681, 147692, 147715 to 147716, 147727, 147737, 147775 to 147776, 147780, 147790, 147797 to 147799, 147804, 147807, 147831, 147834, 147875 to 147877, 147884, 147893, 147910, 147917, 147938, 147964, 147966, 147995, 148043, 148054, 148057, 148086 to 148088, 148100, 148115, 148117, 148133, 148159, 148161, 148169 to 148170, 148206, 148218, 148237, 148250, 148276, 148296, 148322 to 148325, 148364, 148374, 148380, 148412 to 148413, 148417, 148457 to 148458, 148466, 148472, 148484, 148533 to 148534, 148570 to 148571, 148595, 148615 to 148616, 148665, 148668, 148686, 148691, 148694, 148741, 148769, 148856, 148936, 149016, 149033 to 149034, 149093, 149108, 149143, 149157, 149204, 149254, 149285, 149295, 149391, 149472, 149489, 149522, 149539, 149634, 149654, 149737, 149744 to 149747, 149755, 149759 to 149761, 149772, 149782 to 149783, 149785, 149807, 149811 to 149812, 149822 to 149827, 149858 to 149859, 149876 to 149878, 149883, 149887, 149890, 149896 to 149903, 149908, 149924, 149927, 149929, 149931 to 149933, 149943 to 149947, 149957, 149968, 149978, 149982 to 149983, 149987, 149989, 149996 to 149997, 150006 to 150009, 150011, 150030, 150034 to 150035, 150037, 150049 to 150058, 150078, 150082, 150085, 150090, 150093 to 150097, 150109, 150117 to 150119, 150129, 150135 to 150138, 150156, 150163 to 150166, 150180 to 150183, 150193 to 150195, 150202 to 150204, 150208, 150215, 150218, 150225, 150239, 150242, 150249, 150287, 150358, 150382 to 150383, 150517, 150537, 150550, 150686 to 150687, 150729, 150745, 150790, 150803 to 150804, 150968, 151018 to 151019, 151054, 151095, 151099, 151120, 151146, 151179, 151205, 151207, 151310, 151388, 151426, 151430, 151447, 151450, 151465, 151480, 151490, 151596, 151626, 151634, 151637, 151709, 151842, 151851, 151880, 151933 to 151934, 151977, 152013, 152035, 152037 to 152039, 152094, 152096 to 152097, 152140, 152144, 152217, 152263, 152280, 152334, 152337, 152339, 152601, 152613, 152622 to 152624, 152646, 152684, 152686, 152718, 152730, 152793, 152846, 152881, 152885, 152895, 152923 to 152926, 152930, 152933 to 152934, 152961, 152964, 152975, 152999, 153017, 153045, 153051, 153056, 153093, 153141, 153169, 153219, 153237, 153315, 153334, 153350, 153373, 153381, 153405, 153457 to 153458, 153513, 153524, 153543, 153567 to 153569, 153687, 153693, 153714, 153800, 153825, 153859, 153926, 153942, 154028, 154052, 154060, 154068, 154196, 154261, 154268, 154286 to 154287, 154339 to 154340, 154345, 154353, 154484, 154505, 154546 to 154548, 154566, 154596, 154600, 154625, 154630, 154657, 154698 to 154699, 154724 to 154725, 154769, 154788, 154816 to 154817, 154878, 154912, 154928, 154947, 155041, 155150, 155182, 155209, 155222, 155234, 155237, 155265 to 155267, 155302, 155324, 155330, 155351 to 155352, 155368, 155418, 155427, 155467, 155484, 155604, 155616 to 155618, 155643, 155660, 155671, 155689, 155720, 155744, 155748, 155779, 155799, 155812 to 155813, 155885, 155906, 155937, 155993 to 155996, 156077 to 156078, 156082, 156125, 156248, 156257, 156266 to 156267, 156272, 156294, 156368, 156469, 156491 to 156492, 156497, 156606, 156661, 156664, 156674, 156688 to 156690, 156746, 156777, 156804, 156808 to 156809, 156813, 156824, 156946, 157042, 157088, 157101, 157119, 157202, 157222, 157310, 157359 to 157361, 157365, 157402, 157416, 157436, 157462, 157469, 157505, 157593, 157619 to 157620, 157644, 157724, 157766, 157790, 157806, 157832, 157834, 157843, 157895, 157917, 157930, 157966, 157969, 157990, 158009, 158033, 158063, 158120, 158133, 158173, 158194, 158202, 158238, 158253 to 158254, 158260, 158274, 158289 to 158290, 158296, 158348, 158391, 158463, 158469, 158474, 158483, 158485, 158499, 158504, 158544 to 158547, 158555, 158581, 158594, 158614 to 158615, 158621, 158643, 158656, 158711, 158753, 158761, 158784 to 158785, 158790, 158835, 158846 to 158850, 158884, 158903 to 158904, 158909, 158912, 158915, 158929, 158941, 159010 to 159018, 159057, 159092, 159136 to 159143, 159150, 159196, 159210 to 159211, 159216, 159232, 159237, 159239, 159250, 159296, 159298 to 159301, 159333, 159342, 159346, 159351, 159364, 159371, 159385, 159440 to 159447, 159526, 159603 to 159604, 159636, 159647, 159649, 159678, 159710 to 159711, 159734 to 159736, 159758, 159819, 159826 to 159827, 159880, 159917 to 159919, 159949, 159954, 159988, 159992, 160009, 160012 to 160013, 160038 to 160039, 160057, 160100 to 160101, 160117, 160205, 160283, 160359, 160384, 160389, 160395, 160434, 160438, 160486, 160594, 160666, 160730 to 160731, 160766 to 160767, 160784, 160802, 160841, 160848, 160900, 160902, 161140, 161187, 161248, 161252, 161277 to 161278, 161287, 161292, 161300 to 161301, 161329 to 161330, 161337, 161365 to 161367, 161412, 161427 to 161428, 161550 to 161551, 161571, 161589 to 161590, 161601, 161618, 161630, 161668 to 161669, 161740, 161880, 161904, 161949, 161970, 161992, 162084, 162151, 162170, 162181, 162208, 162269, 162301, 162314, 162318, 162366, 162387, 162393, 162425, 162436, 162493 to 162494, 162548, 162566, 162571, 162584, 162616 to 162618, 162632, 162739, 162750, 162759, 162799, 162804, 162834, 162924, 162993, 163000, 163013, 163119, 163155 to 163156, 163174, 163187, 163204, 163215, 163224, 163232, 163261, 163292, 163344, 163405, 163407, 163630, 163767, 163833, 163842, 163849, 163870, 163875 to 163876, 163912, 163971, 163978, 163984, 164027, 164029 to 164030, 164072 to 164073, 164084, 164142, 164175, 164189, 164207, 164233, 164271, 164284, 164359, 164376, 164378, 164438, 164471, 164476, 164482, 164507, 164557, 164578, 164595, 164614, 164632, 164655, 164666, 164709, 164717, 164733, 164746, 164813, 164876, 164882, 164949, 164968, 164972, 164979, 164994, 165121, 165180 to 165181, 165227 to 165228, 165320 to 165321, 165352, 165364, 165376, 165387, 165413, 165435, 165546 to 165547, 165554, 165564, 165591 to 165592, 165606, 165626, 165647, 165651, 165892, 165931, 166195, 166214, 166216 to 166217, 166230, 166244, 166248, 166251 to 166253, 166270, 166279 to 166281, 166312, 166314 to 166315, 166328, 166330 to 166332, 166336, 166364, 166366, 166369, 166371 to 166372, 166375 to 166376, 166393 to 166396, 166415, 166422, 166430, 166437, 166441, 166450, 166454, 166467 to 166475, 166489 to 166490, 166513, 166529 to 166531, 166553 to 166556, 166592, 166598, 166603 to 166606, 166621 to 166629, 166634, 166652, 166668, 166675, 166689 to 166690, 166699 to 166701, 166703, 166726, 166732, 166734, 166736, 166755 to 166758, 166764, 166799, 166809, 166812 to 166813, 166841, 166849 to 166850, 166853, 166868, 166871, 166873 to 166874, 166887 to 166892, 166895, 166901, 166911, 166915, 166921, 166940 to 166941, 166947, 166950, 166955, 166960, 166969, 166971, 167114, 167117, 167122, 167184, 167220, 167281, 167321, 167353, 167419, 167439, 167455, 167478, 167481, 167525 to 167526, 167561, 167575, 167596, 167602 to 167603, 167641, 167655, 167659, 167730, 167877, 167928, 168057, 168072, 168075, 168083, 168111 to 168113, 168128, 168164 to 168165, 168172 to 168173, 168205, 168208, 168252, 168269, 168283, 168286, 168304, 168348, 168360, 168405, 168427, 168608, 168625, 168989, 168992, 169011, 169023, 169032, 169104, 169168, 169177 to 169178, 169189, 169191, 169374, 169392, 169400, 169423, 169431, 169449, 169460, 169599, 169712, 169753, 169760, 169778, 169808, 169940, 170000, 170071, 170148, 170182, 170193, 170218, 170225, 170234, 170243, 170245, 170287, 170309, 170311 to 170313, 170333, 170346, 170397, 170435, 170441, 170536, 170573, 170610, 170757, 170766, 170965, 171123, 171181, 171326, 171354, 171388, 171416, 171419, 171483, 171510, 171526, 171541, 171565, 171581, 171593, 171624, 171658, 171692, 171696, 171715 to 171716, 171739, 171753, 171768, 171811, 171824, 171959, 171982, 171998, 172052, 172058, 172079, 172162, 172167, 172217, 172257, 172269, 172275, 172280 to 172281, 172286, 172295, 172323, 172339 to 172340, 172368, 172432, 172434 to 172435, 172459, 172468 to 172469, 172511, 172533, 172576, 172595, 172691, 172703, 172722, 172724, 172726, 172730, 172733, 172767, 172799, 172881, 172940, 172969, 173108, 173111, 173147, 173510, 173515, 173553, 173569 to 173570, 173594, 173618, 173642, 173659, 173737, 173746"/>
        <result>
          <xsl:for-each select="$testStringCodepoints">
              <xsl:variable name="codePoint" select="." as="xs:decimal"/>
              <xsl:variable name="character" select="codepoints-to-string($codePoint)"/>
              <xsl:choose>
                  <xsl:when test="$codePoint = $allowedGlyphs"><xsl:sequence select="$character"/></xsl:when>
                  <xsl:otherwise><unsupported><xsl:value-of select="concat('*', $character, ' (&amp;#', $codePoint, ';)', '*')"/></unsupported></xsl:otherwise>
              </xsl:choose>               
          </xsl:for-each>
        </result>
    </xsl:function>
</xsl:stylesheet>