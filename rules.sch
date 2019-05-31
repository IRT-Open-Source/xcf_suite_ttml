<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns uri="http://www.irt.de/subcheck" prefix="subcheck"/>

    <sch:ns uri="http://www.w3.org/ns/ttml" prefix="tt"/>
    <sch:ns uri="http://www.w3.org/ns/ttml#parameter" prefix="ttp"/>
    <sch:ns uri="http://www.w3.org/ns/ttml#styling" prefix="tts"/>
    <sch:ns uri="http://www.w3.org/ns/ttml#audio" prefix="tta"/>
    <sch:ns uri="http://www.w3.org/ns/ttml#metadata" prefix="ttm"/>
    <sch:ns uri="urn:ebu:tt:style" prefix="ebutts"/>
    <sch:ns uri="urn:ebu:tt:metadata" prefix="ebuttm"/>
    <sch:ns uri="http://www.w3.org/ns/ttml/profile/imsc1#parameter" prefix="ittp"/>
    <sch:ns uri="http://www.w3.org/ns/ttml/profile/imsc1#styling" prefix="itts"/>
    <sch:ns uri="http://www.w3.org/ns/ttml/profile/imsc1#metadata" prefix="ittm"/>
    <sch:ns uri="http://www.smpte-ra.org/schemas/2052-1/2010/smpte-tt" prefix="smpte"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>

    <!--##############
        XSLT functions
        ##############-->

    <xsl:include href="irt_functions.xsl"/>
    

    <!--#############
        shared values
        #############-->

    <!-- matches clock-time with frames / offset-time with f -->
    <sch:let name="regex_frames" value="'^\d{2,}:\d\d:\d\d:\d{2,}(\.\d+)?$|^\d+(\.\d+)?f$'"/>
    <!-- matches offset-time with t -->
    <sch:let name="regex_ticks" value="'^\d+(\.\d+)?t$'"/>
    <!-- matches display aspect ratio -->
    <sch:let name="regex_display_aspect_ratio" value="'^\d*[1-9]\d* \d*[1-9]\d*$'"/>


    <!--########
        patterns
        ########-->

    <!-- This PATTERN tests if attributes are present that are in a TTML namespace but not defined by TTML -->
    <!--                                                                                                   -->
    <sch:pattern id="attributeDefined">
        <sch:rule context="attribute::ttm:*">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jz" id="assert-hlm_gvk_jz-1"
                test="
                    local-name(.) = (
                        'agent', 'role'
                    )">
                All TT Metadata namespace attributes are defined by the TTML specification.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jza" id="assert-hlm_gvk_jza-1"
                test="
                    local-name(.) = (
                        'agent', 'role'
                    )">
                All TT Metadata namespace attributes are defined by the TTML specification.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:*">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jz" id="assert-hlm_gvk_jz-2"
                test="
                    local-name(.) = (
                        'cellResolution', 'clockMode', 'dropMode', 'frameRate', 'frameRateMultiplier', 'markerMode', 'pixelAspectRatio', 'profile', 'subFrameRate', 'tickRate', 'timeBase'
                    )">
                All TT Parameter namespace attributes are defined by the TTML specification.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jza" id="assert-hlm_gvk_jza-2"
                test="
                    local-name(.) = (
                        'cellResolution', 'clockMode', 'displayAspectRatio', 'dropMode', 'frameRate', 'frameRateMultiplier', 'markerMode', 'pixelAspectRatio', 'subFrameRate', 'tickRate', 'timeBase',
                        'contentProfiles', 'contentProfileCombination', 'inferProcessorProfileMethod', 'inferProcessorProfileSource', 'permitFeatureNarrowing', 'permitFeatureWidening', 'processorProfiles',
                        'processorProfileCombination', 'profile', 'validation', 'validationAction'
                    )">
                All TT Parameter namespace attributes are defined by the TTML specification.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:*">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jz" id="assert-hlm_gvk_jz-3"
                test="
                    local-name(.) = (
                        'backgroundColor', 'color', 'direction', 'display', 'displayAlign', 'extent', 'fontFamily', 'fontSize', 'fontStyle', 'fontWeight', 'lineHeight', 'opacity',
                        'origin', 'overflow', 'padding', 'showBackground', 'textAlign', 'textDecoration', 'textOutline', 'unicodeBidi', 'visibility', 'wrapOption', 'writingMode', 'zIndex'
                    )">
                All TT Style namespace attributes are defined by the TTML specification.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/hlm_gvk_jza" id="assert-hlm_gvk_jza-3"
                test="
                    local-name(.) = (
                        'backgroundClip', 'backgroundColor', 'backgroundExtent', 'backgroundImage', 'backgroundOrigin', 'backgroundPosition', 'backgroundRepeat', 'border', 'bpd', 'color', 'direction', 'disparity',
                        'display', 'displayAlign', 'extent', 'fontFamily', 'fontKerning', 'fontSelectionStrategy', 'fontShear', 'fontSize', 'fontStyle', 'fontVariant', 'fontWeight', 'ipd', 'letterSpacing',
                        'lineHeight', 'lineShear', 'luminanceGain', 'opacity', 'origin', 'overflow', 'padding', 'position', 'ruby', 'rubyAlign', 'rubyPosition', 'rubyReserve', 'shear', 'showBackground',
                        'textAlign', 'textCombine', 'textDecoration', 'textEmphasis', 'textOrientation', 'textOutline', 'textShadow', 'unicodeBidi', 'visibility', 'wrapOption', 'writingMode', 'zIndex'
                    )">
                All TT Style namespace attributes are defined by the TTML specification.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if attributes are on elements where explicitely forbidden -->
    <!--                                                                              -->
    <sch:pattern id="attributeNamespace">
        <sch:rule context="attribute::ttp:*">
            <sch:assert test="parent::tt:tt" diagnostics="attributeDefinedOn" id="assert-w0ab1b5d181-1" see="http://www.irt.de/subcheck/constraints/w0ab1b5d181">Attributes on the
                parameter namespace appear only on the tt element.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:*[local-name() != 'extent' ]">
            <sch:assert
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:style | parent::tt:region | parent::tt:set"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d183" id="assert-w0ab1b5d183-1">With the exception of tts:extent all attributes in the style namespace appear only on
                the following elements: body, div, span, p, br, style, region or set.</sch:assert>
            <sch:assert
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:initial | parent::tt:style | parent::tt:region | parent::tt:set"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d183a" id="assert-w0ab1b5d183a-1">With the exception of tts:extent all attributes in the style namespace appear only on
                the following elements: body, div, span, p, br, initial, style, region or set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent">
            <sch:assert
                test="parent::tt:tt | parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:style | parent::tt:region | parent::tt:set"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d183" id="assert-w0ab1b5d183-2">The tts:extent attribute appears only on
                the following elements: tt, body, div, span, p, br, style, region or set.</sch:assert>
            <sch:assert
                test="parent::tt:tt | parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:initial | parent::tt:style | parent::tt:region | parent::tt:set"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d183a" id="assert-w0ab1b5d183a-2">The tts:extent attribute appears only on
                the following elements: tt, body, div, span, p, br, initial, style, region or set.</sch:assert>
        </sch:rule>        
        <sch:rule context="attribute::ttm:*[local-name() != 'role']">
            <sch:assert
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:metadata"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d185" id="assert-w0ab1b5d185-1">With the exception of ttm:role all attributes in the TTML metadata namespace appear
                only on the following elements: body, div, p, span, br and metadata. </sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttm:role">
            <sch:assert
                test="parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:br | parent::tt:metadata | parent::tt:region"
                diagnostics="attributeDefinedOn" see="http://www.irt.de/subcheck/constraints/w0ab1b5d185" id="assert-w0ab1b5d185-2">The ttm:role attribute appears only on
                the following elements: body, div, span, p, br, metadata or region.</sch:assert>
        </sch:rule>   
    </sch:pattern>

    <!-- This PATTERN tests generic aspects e.g. the document encoding and the root element -->
    <!--                                                                                    -->
    <sch:pattern id="generic">
        <sch:rule context="/">
            <sch:let name="doc_enc" value="subcheck:document_encoding(.)"/>
            <sch:assert diagnostics="documentEncoding"
                test="every $enc in $doc_enc satisfies upper-case($enc) eq 'UTF-8'" id="assert-d1e1004-1"
                see="http://www.irt.de/subcheck/constraints/d1e1004">
                The document encoding (if set) is UTF-8.</sch:assert>
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d215" id="assert-w0ab1b5d215-1"
                test="exists($doc_enc)">
                A document encoding is specified in the XML declaration.
            </sch:assert>
            
            <sch:assert test="tt:tt" id="assert-d1e1164-1"
                see="http://www.irt.de/subcheck/constraints/d1e1164">
                The root element is the tt:tt element.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if and which TTML profile(s) is/are signalled by the document -->
    <!--                                                                                  -->
    <sch:pattern id="profileSignalling">
        <sch:rule context="/tt:tt">
            <sch:let name="signalling_present_imsc1_text"
                value="subcheck:imsc1_signalling_present(., 'http://www.w3.org/ns/ttml/profile/imsc1/text')"/>
            <sch:let name="signalling_present_imsc1_image"
                value="subcheck:imsc1_signalling_present(., 'http://www.w3.org/ns/ttml/profile/imsc1/image')"/>
            <sch:assert test="$signalling_present_imsc1_text" id="assert-d1e1126-1"
                see="http://www.irt.de/subcheck/constraints/d1e1126">The IMSC1 Text profile should be signalled.</sch:assert>
            <!--<sch:assert test="$signalling_present_imsc1_image" id="assert-jhv_htn_fz-1" see="http://www.irt.de/subcheck/constraints/jhv_htn_fz">The IMSC1 Image profile should be signalled.</sch:assert>-->
            <sch:assert
                test="not($signalling_present_imsc1_text and $signalling_present_imsc1_image)"
                id="assert-d1e2288-1"
                see="http://www.irt.de/subcheck/constraints/d1e2288">Either the IMSC1 Text profile or the IMSC1 Image Profile is signalled at the same time.</sch:assert>
            <sch:assert test="not(@ttp:profile and tt:head/ttp:profile)"
                id="assert-d1e2589-1"
                see="http://www.irt.de/subcheck/constraints/d1e2589">
                The ttp:profile attribute is not used when the tt:profile element is present.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if every content is convered by timing information -->
    <!--                                                                       -->
    <sch:pattern id="contentTimingInformation">
        <sch:rule context="/tt:tt/tt:body//tt:div//*[(self::tt:p or self::tt:span) and (child::text()[normalize-space(.) ne ''] or child::tt:br)]">
            <sch:assert test="ancestor-or-self::*[@begin] and ancestor-or-self::*[@end or @dur]"
                id="assert-d1e1528-1"
                see="http://www.irt.de/subcheck/constraints/d1e1528">The begin and the end (or instead the dur) attribute
                are present on the containing element or one of its ancestors.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests the ittm:altText constraints -->
    <!--                                                 -->
    <sch:pattern id="altTextConstraints">
        <sch:rule context="ittm:altText">
            <sch:assert test="not(child::*)" id="assert-d1e2152-1"
                see="http://www.irt.de/subcheck/constraints/d1e2152">
                The ittm:altText element has solely #PCDATA content.</sch:assert>
            <sch:assert test="parent::tt:metadata" id="assert-d1e2179-1" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/d1e2179">
                The ittm:altText element is child of a tt:metadata element.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if a style reference loop is present -->
    <!--                                                         -->
    <sch:pattern id="styleReferenceLoop">
        <sch:rule context="/tt:tt/tt:head/tt:styling/tt:style">
            <sch:assert test="not(subcheck:ttml_style_chain_exists(., ., ()))" id="assert-d1e2616-1" diagnostics="elementId"
                see="http://www.irt.de/subcheck/constraints/d1e2616">There is no loop in the style references.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests if a metadata item element has the correct children -->
    <!--                                                                        -->
    <sch:pattern id="metadataItemChildren">
        <sch:rule context="ttm:item">
            <sch:assert test="not(text()[normalize-space(.) ne ''] and ttm:item)" id="assert-d1e2618-1" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/d1e2618">The ttm:item element has either text node or ttm:item element children.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests (among others) if the tts:ruby nesting constraints are met -->
    <!--                                                                -->
    <sch:pattern id="ttsRubyNestingConstraints">
        <sch:rule context="tt:span[/tt:tt//@tts:ruby != 'none']">
            <!-- precalculate ruby values that are used more than once -->
            <sch:let name="ruby_this" value="subcheck:get_tts_ruby(., true())"/>
            <sch:let name="ruby_ancestors" value="for $n in ancestor::* return subcheck:get_tts_ruby($n, true())"/>
            <sch:let name="ruby_parent" value="$ruby_ancestors[last()]"/>
            <sch:let name="ruby_children" value="for $n in * return subcheck:get_tts_ruby($n, true())"/>
            <sch:let name="ruby_children_position" value="for $n in * return subcheck:get_style_property($n, xs:QName('tts:rubyPosition'), true(), (), 'outside', true())"/>
            <sch:let name="ruby_siblings_preceding" value="for $n in preceding-sibling::* return subcheck:get_tts_ruby($n, true())"/>
            <sch:let name="ruby_siblings_following" value="for $n in following-sibling::* return subcheck:get_tts_ruby($n, true())"/>
            <sch:let name="ruby_descendants" value="for $n in descendant::* return subcheck:get_tts_ruby($n, true())"/>
            
            <!-- check for both ruby text containers on same relative side -->
            <sch:assert test="$ruby_this ne 'container' or count($ruby_children) ne 3 or $ruby_children[2] ne 'textContainer' or $ruby_children[3] ne 'textContainer' or not(
                ($ruby_children_position[2] = ('before', 'outside') and $ruby_children_position[3] eq 'before') or $ruby_children_position[2] eq 'after' and $ruby_children_position[3] = ('after', 'outside')
                )" id="assert-w0ab1b7d223-1" diagnostics="elementChildOf" see="http://www.irt.de/subcheck/constraints/w0ab1b7d223">Both ruby text containers are not on the same relative side.</sch:assert>
            
            <!-- container -->
            <!-- TODO: ancestor vs. ISD? -->
            <sch:assert test="$ruby_this ne 'container' or not($ruby_ancestors != 'none')" id="assert-w0ab1b7d215-1" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is container, then the computed value of tts:ruby of all ancestor elements is none.</sch:assert>
            <sch:assert test="$ruby_this ne 'container' or not($ruby_children = 'none')" id="assert-w0ab1b7d215-2" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is container, then the computed value of tts:ruby of each of its child elements is not none.</sch:assert>
            <sch:assert test="$ruby_this ne 'container' or $ruby_children[1] = ('baseContainer', 'base')" id="assert-w0ab1b7d215-3" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is container, then the computed value of tts:ruby of its first child element is baseContainer or base.</sch:assert>
            <sch:assert test="$ruby_this ne 'container' or (every $x in text() satisfies normalize-space($x) eq '')" id="assert-w0ab1b7d215-4" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is container, then each of its text node children contain only &lt;lwsp&gt;.</sch:assert>
            
            <!-- baseContainer -->
            <sch:assert test="$ruby_this ne 'baseContainer' or $ruby_parent eq 'container'" id="assert-w0ab1b7d215-5" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is baseContainer, then the computed value of tts:ruby of its parent element is container.</sch:assert>
            <sch:assert test="$ruby_this ne 'baseContainer' or not($ruby_children = 'none')" id="assert-w0ab1b7d215-6" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is baseContainer, then the computed value of tts:ruby of each of its child elements is not none.</sch:assert>
            <sch:assert test="$ruby_this ne 'baseContainer' or $ruby_children[1] eq 'base'" id="assert-w0ab1b7d215-7" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is baseContainer, then the computed value of tts:ruby of its first child element is base.</sch:assert>
            <sch:assert test="$ruby_this ne 'baseContainer' or empty($ruby_siblings_preceding)" id="assert-w0ab1b7d215-8" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is baseContainer, then its preceding sibling is null (i.e., no preceding sibling).</sch:assert>
            <sch:assert test="$ruby_this ne 'baseContainer' or (every $x in text() satisfies normalize-space($x) eq '')" id="assert-w0ab1b7d215-9" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is baseContainer, then each of its text node children contain only &lt;lwsp&gt;.</sch:assert>
            
            <!-- textContainer -->
            <sch:assert test="$ruby_this ne 'textContainer' or $ruby_parent eq 'container'" id="assert-w0ab1b7d215-10" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is textContainer, then the computed value of tts:ruby of its parent element is container.</sch:assert>
            <sch:assert test="$ruby_this ne 'textContainer' or not($ruby_children = 'none')" id="assert-w0ab1b7d215-11" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is textContainer, then the computed value of tts:ruby of each of its child elements is not none.</sch:assert>
            <sch:assert test="$ruby_this ne 'textContainer' or $ruby_children[1] = ('text', 'delimiter')" id="assert-w0ab1b7d215-12" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is textContainer, then the computed value of tts:ruby of its first child element is either text or delimiter.</sch:assert>
            <sch:assert test="$ruby_this ne 'textContainer' or $ruby_siblings_preceding[last()] = ('baseContainer', 'textContainer')" id="assert-w0ab1b7d215-13" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is textContainer, then the computed value of tts:ruby of its preceding sibling is baseContainer or textContainer.</sch:assert>
            <sch:assert test="$ruby_this ne 'textContainer' or count(($ruby_siblings_preceding, $ruby_siblings_following)[. eq 'textContainer']) le 1" id="assert-w0ab1b7d215-14" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is textContainer, then the computed value of tts:ruby of no more than one sibling is textContainer.</sch:assert>
            <sch:assert test="$ruby_this ne 'textContainer' or (every $x in text() satisfies normalize-space($x) eq '')" id="assert-w0ab1b7d215-15" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is textContainer, then each of its text node children contain only &lt;lwsp&gt;.</sch:assert>
            
            <!-- base -->
            <sch:assert test="$ruby_this ne 'base' or $ruby_parent = ('container', 'baseContainer')" id="assert-w0ab1b7d215-16" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is base, then the computed value of tts:ruby of its parent element is either container or baseContainer.</sch:assert>
            <sch:assert test="$ruby_this ne 'base' or empty($ruby_siblings_preceding) or $ruby_siblings_preceding[last()] eq 'base'" id="assert-w0ab1b7d215-17" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is base, then its preceding sibling is either null (i.e., no preceding sibling) or the computed value of tts:ruby of its preceding sibling is base.</sch:assert>
            <sch:assert test="$ruby_this ne 'base' or $ruby_parent ne 'container' or not(($ruby_siblings_preceding, $ruby_siblings_following) = 'base')" id="assert-w0ab1b7d215-18" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is base and the computed value of tts:ruby of its parent element is container, then the computed value of tts:ruby of no sibling is base.</sch:assert>
            <sch:assert test="$ruby_this ne 'base' or not($ruby_descendants != 'none')" id="assert-w0ab1b7d215-19" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is base, then the computed value of tts:ruby of no descendant element is not none.</sch:assert>
            <sch:assert test="$ruby_this ne 'base' or not(descendant::tt:br)" id="assert-w0ab1b7d215-20" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is base, then none of its descendant elements is a br element.</sch:assert>
            <sch:assert test="$ruby_this ne 'base' or (every $x in text() satisfies not(contains($x, '&#x2028;') or contains($x, '&#x2029;')))" id="assert-w0ab1b7d215-21" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is base, then each of its text node descendants does not contain U+2028 (LINE SEPARATOR) or U+2029 (PARAGRAPH SEPARATOR).</sch:assert>
            
            <!-- text -->
            <sch:assert test="$ruby_this ne 'text' or $ruby_parent = ('container', 'textContainer')" id="assert-w0ab1b7d215-22" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is text, then the computed value of tts:ruby of its parent element is either container or textContainer.</sch:assert>
            <sch:assert test="$ruby_this ne 'text' or empty($ruby_siblings_preceding) or $ruby_siblings_preceding[last()] = ('base', 'text', 'delimiter')" id="assert-w0ab1b7d215-23" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is base, then its preceding sibling is either null (i.e., no preceding sibling) or the computed value of tts:ruby of its preceding sibling is base, text, or delimiter.</sch:assert>
            <sch:assert test="$ruby_this ne 'text' or $ruby_parent ne 'container' or not(($ruby_siblings_preceding, $ruby_siblings_following) = 'text')" id="assert-w0ab1b7d215-24" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is text and the computed value of tts:ruby of its parent element is container, then the computed value of tts:ruby of no sibling is text.</sch:assert>
            <sch:assert test="$ruby_this ne 'text' or not($ruby_descendants != 'none')" id="assert-w0ab1b7d215-25" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is text, then the computed value of tts:ruby of no descendant element is not none.</sch:assert>
            
            <!-- delimiter -->
            <sch:assert test="$ruby_this ne 'delimiter' or $ruby_parent = ('container', 'textContainer')" id="assert-w0ab1b7d215-26" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is delimiter, then the computed value of tts:ruby of its parent element is either container or textContainer.</sch:assert>
            
            <!-- text -->
            <sch:assert test="$ruby_this ne 'text' or not(descendant::tt:br)" id="assert-w0ab1b7d215-27" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is text, then none of its descendant elements is a br element.</sch:assert>
            <sch:assert test="$ruby_this ne 'text' or (every $x in text() satisfies not(contains($x, '&#x2028;') or contains($x, '&#x2029;')))" id="assert-w0ab1b7d215-28" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is text, then each of its text node descendats does not contain U+2028 (LINE SEPARATOR) or U+2029 (PARAGRAPH SEPARATOR).</sch:assert>
            
            <!-- delimiter -->
            <sch:assert test="$ruby_this ne 'delimiter' or empty($ruby_siblings_preceding) or $ruby_siblings_preceding[last()] = ('base', 'text')" id="assert-w0ab1b7d215-29" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is delimiter, then its preceding sibling is either null (i.e., no preceding sibling) or the computed value of tts:ruby of its preceding sibling is base or text.</sch:assert>
            <sch:assert test="$ruby_this ne 'delimiter' or count(($ruby_siblings_preceding, $ruby_siblings_following)[. eq 'delimiter']) eq 1" id="assert-w0ab1b7d215-30" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is delimiter, then the computed value of tts:ruby of exactly one sibling is delimiter.</sch:assert>
            <sch:assert test="$ruby_this ne 'delimiter' or not($ruby_descendants != 'none')" id="assert-w0ab1b7d215-31" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is delimiter, then the computed value of tts:ruby of no descendant element is not none.</sch:assert>
            <sch:assert test="$ruby_this ne 'delimiter' or not(descendant::tt:br)" id="assert-w0ab1b7d215-32" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is delimiter, then none of its descendant elements is a br element.</sch:assert>
            <sch:assert test="$ruby_this ne 'delimiter' or (every $x in text() satisfies not(contains($x, '&#x2028;') or contains($x, '&#x2029;')))" id="assert-w0ab1b7d215-33" diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d215">The following constraint is violated: If the computed value of tts:ruby is delimiter, then each of its text node descendants does not contain U+2028 (LINE SEPARATOR) or U+2029 (PARAGRAPH SEPARATOR).</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests for the presence of forbidden elements -->
    <!--                                                           -->
    <sch:pattern id="elementPresence">
        <sch:rule context="tt:animate">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c33Aa" id="assert-w0ab1b7c33Aa-1"
                test="false()">The element tt:animate is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:animation">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c49Aa" id="assert-w0ab1b7c49Aa-1"
                test="false()">The element tt:animation is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:audio">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c35Aa" id="assert-w0ab1b7c35Aa-1"
                test="false()">The element tt:audio is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:chunk">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c38Aa" id="assert-w0ab1b7c38Aa-1"
                test="false()">The element tt:chunk is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:data">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c39Aa" id="assert-w0ab1b7c39Aa-1"
                test="false()">The element tt:data is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:resources">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c41Aa" id="assert-w0ab1b7c41Aa-1"
                test="false()">The element tt:resources is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:source">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c43Aa" id="assert-w0ab1b7c43Aa-1"
                test="false()">The element tt:source is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:font">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c45Aa" id="assert-w0ab1b7c45Aa-1"
                test="false()">The element tt:font is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:image">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c47Aa" id="assert-w0ab1b7c47Aa-1"
                test="false()">The element tt:image is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:region[parent::tt:div | parent::tt:p]">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c51" id="assert-w0ab1b7c51-1"
                test="false()">The element tt:region is not present as child of any of the following elements: tt:div, tt:p.</sch:assert>
        </sch:rule>
        <sch:rule context="ttp:profile[parent::ttp:profile]">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c56" id="assert-w0ab1b7c56-1"
                test="false()">The element ttp:profile is not present as child of another ttp:profile element.</sch:assert>
        </sch:rule>
        <sch:rule context="smpte:image">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c37Aa" id="assert-w0ab1b7c37Aa-1"
                test="false()">The element smpte:image is not present.</sch:assert>
        </sch:rule>
        <sch:rule context="ittm:altText[//ttm:item[@name eq 'altText']] | ttm:item[@name eq 'altText'][//ittm:altText]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d161" id="assert-w0ab1b7d161-1"
                test="false()">The element ittm:altText and the altText named metadata item are not present in the same document.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests for the presence of deprecated elements -->
    <!--                                                            -->
    <sch:pattern id="elementDeprecated">
        <sch:rule context="ittm:altText">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d177Aa" id="assert-w0ab1b7d177Aa-1"
                test="false()">The element ittm:altText is not present.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests whether attributes are significant on the respective element -->
    <!--                                                                                 -->
    <sch:pattern id="attributeSignificance">
        <sch:rule context="attribute::tts:backgroundColor">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e2" id="assert-d1e2-1"
                test="(. | parent::tt:set)[parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:region] | parent::tt:style"
                >The attribute tts:backgroundColor is defined on one of the following elements:
                tt:body, tt:div, tt:p, tt:span, tt:region (or on a tt:set child of them), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e2a" id="assert-d1e2a-1"
                test="(. | parent::tt:set)[parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:region] | parent::tt:style | parent::tt:initial"
                >The attribute tts:backgroundColor is defined on one of the following elements:
                tt:body, tt:div, tt:p, tt:span, tt:region (or on a tt:set child of them), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:contentProfiles">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d231" id="assert-w0ab1b7d231-1"
                test="parent::tt:tt">The attribute ttp:contentProfiles is defined on the
                following element: tt:tt.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:disparity">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d227" id="assert-w0ab1b7d227-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:disparity is defined
                on one of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:display">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e23" id="assert-d1e23-1"
                test="(. | parent::tt:set)[parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:region] | parent::tt:style"
                >The attribute tts:display is defined on one of the following elements: tt:body,
                tt:div, tt:p, tt:span, tt:region (or on a tt:set child of them), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e23a" id="assert-d1e23a-1"
                test="(. | parent::tt:set)[parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:region] | parent::tt:style | parent::tt:initial"
                >The attribute tts:display is defined on one of the following elements: tt:body,
                tt:div, tt:p, tt:span, tt:region (or on a tt:set child of them), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:displayAlign">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e44" id="assert-d1e44-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style">The attribute tts:displayAlign is defined
                on one of the following elements: tt:region (or on a tt:set child of it), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e44a" id="assert-d1e44a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:displayAlign is defined
                on one of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:displayAspectRatio">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d229" id="assert-w0ab1b7d229-1"
                test="parent::tt:tt">The attribute ttp:displayAspectRatio is defined on the
                following element: tt:tt.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e65" id="assert-d1e65-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:tt">The attribute tts:extent is
                defined on one of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:tt.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e65a" id="assert-d1e65a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:tt | parent::tt:initial">The attribute tts:extent is
                defined on one of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:tt, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:luminanceGain">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d225" id="assert-w0ab1b7d225-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:luminanceGain is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:opacity">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e86" id="assert-d1e86-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style">The attribute tts:opacity is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e86a" id="assert-d1e86a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:opacity is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:origin">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e107" id="assert-d1e107-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style">The attribute tts:origin is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e107a" id="assert-d1e107a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:origin is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:overflow">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e128" id="assert-d1e128-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style">The attribute tts:overflow is defined on
                one of the following elements: tt:region (or on a tt:set child of it), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e128a" id="assert-d1e128a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:overflow is defined on
                one of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:padding">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e149" id="assert-d1e149-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style">The attribute tts:padding is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e149a" id="assert-d1e149a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:padding is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:position">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d235" id="assert-w0ab1b7d235-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:position is defined
                on one of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:ruby">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e236" id="assert-d1e236-1"
                test="parent::tt:span | parent::tt:style | parent::tt:initial">The attribute tts:ruby is defined on one
                of the following elements: tt:span, tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:showBackground">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e170" id="assert-d1e170-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style">The attribute tts:showBackground is defined on one of the
                following elements: tt:region (or on a tt:set child of it), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e170a" id="assert-d1e170a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:showBackground is defined on one of the
                following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:unicodeBidi">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e191" id="assert-d1e191-1"
                test="(. | parent::tt:set)[parent::tt:p | parent::tt:span] | parent::tt:style">The attribute tts:unicodeBidi
                is defined on one of the following elements: tt:p, tt:span (or on a tt:set child of them), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e191a" id="assert-d1e191a-1"
                test="(. | parent::tt:set)[parent::tt:p | parent::tt:span] | parent::tt:style | parent::tt:initial">The attribute tts:unicodeBidi
                is defined on one of the following elements: tt:p, tt:span (or on a tt:set child of them), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:writingMode">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e212" id="assert-d1e212-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style">The attribute tts:writingMode is defined on
                one of the following elements: tt:region (or on a tt:set child of it), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e212a" id="assert-d1e212a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:writingMode is defined on
                one of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:zIndex">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e234" id="assert-d1e234-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style">The attribute tts:zIndex is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style.</sch:assert>
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e234a" id="assert-d1e234a-1"
                test="(. | parent::tt:set)[parent::tt:region] | parent::tt:style | parent::tt:initial">The attribute tts:zIndex is defined on one
                of the following elements: tt:region (or on a tt:set child of it), tt:style, tt:initial.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:aspectRatio">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e1797" id="assert-d1e1797-1"
                test="parent::tt:tt">The attribute ittp:aspectRatio is defined on the
                following element: tt:tt.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::itts:forcedDisplay">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e2014" id="assert-d1e2014-1"
                test="(. | parent::tt:set)[parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:span | parent::tt:region] | parent::tt:style"
                >The attribute itts:forcedDisplay is defined on one of the following elements:
                tt:body, tt:div, tt:p, tt:span, tt:region (or on a tt:set child of them), tt:style.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:progressivelyDecodable">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e1960" id="assert-d1e1960-1"
                test="parent::tt:tt">The attribute ittp:progressivelyDecodable is defined on
                the following element: tt:tt.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:activeArea">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c83Aa" id="assert-w0ab1b7c83Aa-1"
                test="parent::tt:tt">The attribute ittp:activeArea is defined on the
                following element: tt:tt.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::itts:fillLineGap">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c87Aa" id="assert-w0ab1b7c87Aa-1"
                test="(. | parent::tt:set)[parent::tt:body | parent::tt:div | parent::tt:p | parent::tt:region] | parent::tt:style"
                >The attribute itts:fillLineGap is defined on one of the following elements:
                tt:body, tt:div, tt:p, tt:region (or on a tt:set child of them), tt:style.</sch:assert>
        </sch:rule>
        <!-- also check e.g. @ebutts:linePadding ? -->
    </sch:pattern>

    <!-- This PATTERN tests for the presence of required attributes -->
    <!--                                                            -->
    <sch:pattern id="attributeRequirement">
        <sch:rule context="/tt:tt/tt:head/tt:layout/tt:region">
            <sch:assert diagnostics="elementId"
                see="http://www.irt.de/subcheck/constraints/d1e1321" id="assert-d1e1321-1"
                test="attribute::tts:extent">The attribute tts:extent is present.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests for the presence of forbidden attributes -->
    <!--                                                             -->
    <sch:pattern id="attributePresence">
        <sch:rule context="attribute::combine[parent::ttp:profile]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c54" id="assert-w0ab1b7c54-1"
                test="false()">The attribute combine on the ttp:profile element is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::extends[parent::ttp:feature | parent::ttp:extension]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c57" id="assert-w0ab1b7c57-1"
                test="false()">The attribute extends on the ttp:feature or ttp:extension element is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::restricts[parent::ttp:feature | parent::ttp:extension]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c59" id="assert-w0ab1b7c59-1"
                test="false()">The attribute restricts on the ttp:feature or ttp:extension element is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:clockMode">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e199" id="assert-d1e199-1"
                test="false()">The attribute ttp:clockMode is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:contentProfileCombination">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c55" id="assert-w0ab1b7c55-1"
                test="false()">The attribute ttp:contentProfileCombination is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:dropMode">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e228" id="assert-d1e228-1"
                test="false()">The attribute ttp:dropMode is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:pixelAspectRatio">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e341" id="assert-d1e341-1"
                test="false()">The attribute ttp:pixelAspectRatio is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:markerMode">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e314" id="assert-d1e314-1"
                test="false()">The attribute ttp:markerMode is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:subFrameRate">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e368" id="assert-d1e368-1"
                test="false()">The attribute ttp:subFrameRate is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:permitFeatureNarrowing">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c34" id="assert-w0ab1b7c34-1"
                test="false()">The attribute ttp:permitFeatureNarrowing is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:permitFeatureWidening">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c36" id="assert-w0ab1b7c36-1"
                test="false()">The attribute ttp:permitFeatureWidening is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:processorProfiles">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c38" id="assert-w0ab1b7c38-1"
                test="false()">The attribute ttp:processorProfiles is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:processorProfileCombination">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c40" id="assert-w0ab1b7c40-1"
                test="false()">The attribute ttp:processorProfileCombination is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:validation">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c42" id="assert-w0ab1b7c42-1"
                test="false()">The attribute ttp:validation is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:validationAction">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c44" id="assert-w0ab1b7c44-1"
                test="false()">The attribute ttp:validationAction is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:backgroundClip">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c25" id="assert-w0ab1b7c25-1"
                test="false()">The attribute tts:backgroundClip is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:backgroundExtent">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c27" id="assert-w0ab1b7c27-1"
                test="false()">The attribute tts:backgroundExtent is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:backgroundImage">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c29" id="assert-w0ab1b7c29-1"
                test="false()">The attribute tts:backgroundImage is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:backgroundOrigin">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c18" id="assert-w0ab1b7c18-1"
                test="false()">The attribute tts:backgroundOrigin is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:backgroundPosition">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c20" id="assert-w0ab1b7c20-1"
                test="false()">The attribute tts:backgroundPosition is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:backgroundRepeat">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c22" id="assert-w0ab1b7c22-1"
                test="false()">The attribute tts:backgroundRepeat is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:border">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c24" id="assert-w0ab1b7c24-1"
                test="false()">The attribute tts:border is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:bpd">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c26" id="assert-w0ab1b7c26-1"
                test="false()">The attribute tts:bpd is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:disparity[parent::tt:div | parent::tt:p]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c66" id="assert-w0ab1b7c66-1"
                test="false()">The attribute tts:disparity is not used on any of the following elements: tt:div, tt:p.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent[parent::tt:div | parent::tt:p]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c66" id="assert-w0ab1b7c66-2"
                test="false()">The attribute tts:extent is not used on any of the following elements: tt:div, tt:p.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:fontKerning">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c28" id="assert-w0ab1b7c28-1"
                test="false()">The attribute tts:fontKerning is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:fontSelectionStrategy">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c30" id="assert-w0ab1b7c30-1"
                test="false()">The attribute tts:fontSelectionStrategy is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:letterSpacing">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c32" id="assert-w0ab1b7c32-1"
                test="false()">The attribute tts:letterSpacing is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:origin[parent::tt:div | parent::tt:p]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c66" id="assert-w0ab1b7c66-3"
                test="false()">The attribute tts:origin is not used on any of the following elements: tt:div, tt:p.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:position[parent::tt:div | parent::tt:p]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c66" id="assert-w0ab1b7c66-4"
                test="false()">The attribute tts:position is not used on any of the following elements: tt:div, tt:p.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textOrientation">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c46" id="assert-w0ab1b7c46-1"
                test="false()">The attribute tts:textOrientation is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:ipd">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c48" id="assert-w0ab1b7c48-1"
                test="false()">The attribute tts:ipd is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:fontVariant">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c52" id="assert-w0ab1b7c52-1"
                test="false()">The attribute tts:fontVariant is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tta:gain">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c17" id="assert-w0ab1b7c17-1"
                test="false()">The attribute tta:gain is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tta:pan">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c19" id="assert-w0ab1b7c19-1"
                test="false()">The attribute tta:pan is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tta:pitch">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c21" id="assert-w0ab1b7c21-1"
                test="false()">The attribute tta:pitch is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tta:speak">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c23" id="assert-w0ab1b7c23-1"
                test="false()">The attribute tta:speak is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::smpte:backgroundImage">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/d1e508" id="assert-d1e508-1"
                test="false()">The attribute smpte:backgroundImage is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::smpte:backgroundImageVertical">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c31" id="assert-w0ab1b7c31-1"
                test="false()">The attribute smpte:backgroundImageVertical is not
                used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::smpte:backgroundImageHorizontal">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/unm_ytj_lz" id="assert-unm_ytj_lz-1"
                test="false()">The attribute smpte:backgroundImageHorizontal is not
                used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::xlink:arcrole">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c61" id="assert-w0ab1b7c61-1"
                test="false()">The attribute xlink:arcrole is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::xlink:href">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c63" id="assert-w0ab1b7c63-1"
                test="false()">The attribute xlink:href is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::xlink:role">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c65" id="assert-w0ab1b7c65-1"
                test="false()">The attribute xlink:role is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::xlink:show">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c67" id="assert-w0ab1b7c67-1"
                test="false()">The attribute xlink:show is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::xlink:title">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c69" id="assert-w0ab1b7c69-1"
                test="false()">The attribute xlink:title is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::animate">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c64" id="assert-w0ab1b7c64-1"
                test="false()">The attribute animate is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::condition">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c50" id="assert-w0ab1b7c50-1"
                test="false()">The attribute condition is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::fill[parent::tt:set]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c58" id="assert-w0ab1b7c58-1"
                test="false()">The attribute fill is not used on the tt:set element.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::repeatCount[parent::tt:set]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c60" id="assert-w0ab1b7c60-1"
                test="false()">The attribute repeatCount is not used on the tt:set element.</sch:assert>
        </sch:rule>
        <sch:rule context="tt:set">
            <sch:assert diagnostics="elementChildOf"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c62" id="assert-w0ab1b7c62-1"
                test="count((attribute::tts:*, attribute::tta:*)) le 1">
                At most one TT Style Namespaces attribute is present on a tt:set element.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:origin[//attribute::tts:position] | attribute::tts:position[//attribute::tts:origin]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d159" id="assert-w0ab1b7d159-1"
                test="false()">The attributes tts:origin and tts:position are not used in the same document.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:aspectRatio[//attribute::ttp:displayAspectRatio] | attribute::ttp:displayAspectRatio[//attribute::ittp:aspectRatio]">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d163" id="assert-w0ab1b7d163-1"
                test="false()">The attributes ittp:aspectRatio and ttp:displayAspectRatio are not used in the same document.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests for the presence of deprecated attributes -->
    <!--                                                              -->
    <sch:pattern id="attributeDeprecated">
        <sch:rule context="attribute::tts:zIndex">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d175Aa" id="assert-w0ab1b7d175Aa-1"
                test="false()">The attribute tts:zIndex is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:aspectRatio">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d179Aa" id="assert-w0ab1b7d179Aa-1"
                test="false()">The attribute ittp:aspectRatio is not used.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:progressivelyDecodable">
            <sch:assert diagnostics="attributeDefinedOn"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7d181Aa" id="assert-w0ab1b7d181Aa-1"
                test="false()">The attribute ittp:progressivelyDecodable is not used.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests for the correctness of attribute values -->
    <!--                                                            -->
    <sch:pattern id="attributeValues">
        <sch:rule context="ttp:profile">
            <sch:assert see="http://www.irt.de/subcheck/constraints/w0ab1b7c127" id="assert-w0ab1b7c127-1"
                test="normalize-space(attribute::type) eq 'content'">On the ttp:profile element the type attribute is present and has the following value: 'content'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:timeBase">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e398" id="assert-d1e398-1"
                test="normalize-space(.) eq 'media'">The ttp:timeBase attribute has the following value: 'media'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::region[parent::tt:*]"><!-- check for TTML NS parent, as attribute itself has no namespace -->
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1044" id="assert-d1e1044-1"
                test="/tt:tt/tt:head/tt:layout/tt:region[@xml:id eq normalize-space(current())]">
                The region attribute refers to an existing region.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::style[parent::tt:*[not(self::tt:font)]]"><!-- check for TTML NS parent (except TTML2's tt:font), as attribute itself has no namespace -->
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1086" id="assert-d1e1086-1"
                test="every $s in tokenize(normalize-space(.), ' ') satisfies /tt:tt/tt:head/tt:styling/tt:style[@xml:id eq $s]">
                The style attribute refers to an existing style.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:backgroundColor">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c100" id="assert-w0ab1b7c100-1"
                test="matches(normalize-space(.), concat('^', $regex_ttml_color, '$'))">The tts:backgroundColor attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:color">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c102" id="assert-w0ab1b7c102-1"
                test="matches(normalize-space(.), concat('^', $regex_ttml_color, '$'))">The tts:color attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:contentProfiles">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c119" id="assert-w0ab1b7c119-1"
                test="matches(normalize-space(.), concat('^', $regex_profile_designator, '( ', $regex_profile_designator, ')*$|^all\( ', $regex_profile_designator, '( ', $regex_profile_designator, ')* \)$'))">
                The ttp:contentProfiles attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:disparity">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c115" id="assert-w0ab1b7c115-1"
                test="matches(normalize-space(.), concat('^', $regex_length_ttml2, '$'))">The tts:disparity attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:display">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c103" id="assert-w0ab1b7c103-1"
                test="normalize-space(.) = ('auto', 'none')">The tts:display attribute has one of the following values: 'auto', 'none'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:displayAlign">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c101" id="assert-w0ab1b7c101-1"
                test="normalize-space(.) = ('before', 'center', 'after')">The tts:displayAlign attribute has one of the following values: 'before', 'center', 'after'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:displayAspectRatio">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c117" id="assert-w0ab1b7c117-1"
                test="matches(normalize-space(.), $regex_display_aspect_ratio)">
                The ttp:displayAspectRatio attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:fontShear">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c95" id="assert-w0ab1b7c95-1"
                test="matches(normalize-space(.), '^(\+|-)?(\d*\.)?\d+%$')">The tts:fontShear attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:fontSize">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e427" id="assert-d1e427-1"
                test="count(tokenize(normalize-space(.), ' ')) eq 1">The tts:fontSize attribute contains only one value.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-1"
                test="not(contains(., '-'))">The tts:fontSize attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-1"
                test="not(contains(., '-'))">The tts:fontSize attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ttp:inferProcessorProfileSource">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c125" id="assert-w0ab1b7c125-1"
                test="normalize-space(.) eq 'first'">The ttp:inferProcessorProfileSource attribute has the following value: 'first'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:lineHeight">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-2"
                test="not(contains(., '-'))">The tts:lineHeight attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-2"
                test="not(contains(., '-'))">The tts:lineHeight attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:luminanceGain">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c91" id="assert-w0ab1b7c91-1"
                test="matches(normalize-space(.), '^(\d*\.)?\d+$')">The tts:luminanceGain attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:origin">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c53" id="assert-w0ab1b7c53-1"
                test="matches(normalize-space(.), concat('^(auto|(', $regex_length_ttml1, ') (', $regex_length_ttml1, '))$'))">The tts:origin attribute value conforms to the defined syntax.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c53a" id="assert-w0ab1b7c53a-1"
                test="matches(normalize-space(.), concat('^(auto|(', $regex_length_ttml2, ') (', $regex_length_ttml2, '))$'))">The tts:origin attribute value conforms to the defined syntax.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-3"
                test="not(contains(., '-'))">The tts:origin attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-3"
                test="not(contains(., '-'))">The tts:origin attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:padding">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-4"
                test="not(contains(., '-'))">The tts:padding attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-4"
                test="not(contains(., '-'))">The tts:padding attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:position">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c121" id="assert-w0ab1b7c121-1"
                test="matches(normalize-space(.), concat('^', $regex_position, '$'))">The tts:position attribute value conforms to the defined syntax.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-9"
                test="not(contains(., '-'))">The tts:position attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:rubyAlign">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c111" id="assert-w0ab1b7c111-1"
                test="normalize-space(.) = ('center', 'spaceAround')">The tts:rubyAlign attribute has one of the following values: 'center', 'spaceAround'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:rubyReserve">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c113" id="assert-w0ab1b7c113-1"
                test="matches(normalize-space(.), concat('^(none|(both|before|after|outside)( (', $regex_length_ttml2_non_negative , '))?)$'))">The tts:rubyReserve attribute value conforms to the defined syntax.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-8"
                test="not(contains(., '-'))">The tts:rubyReserve attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textAlign">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c105" id="assert-w0ab1b7c105-1"
                test="normalize-space(.) = ('left', 'center', 'right', 'start', 'end')">The tts:textAlign attribute has one of the following values: 'left', 'center', 'right', 'start', 'end'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textCombine">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c93" id="assert-w0ab1b7c93-1"
                test="matches(normalize-space(.), '^(none|all)$')">The tts:textCombine attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textEmphasis">
            <sch:let name="removed_position" value="subcheck:remove_unique_occurence(., 'before|after|outside')"/>
            <sch:let name="removed_style" value="subcheck:remove_unique_occurence($removed_position, 'none|auto|(filled|open)( circle| dot| sesame)?|(circle|dot|sesame)( filled| open)?')"/>
            <!-- after all matches have been removed, no strings shall remain (the original value must not be empty though) -->
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c109" id="assert-w0ab1b7c109-1"
                test="(normalize-space(.) ne '') and empty($removed_style)">The tts:textEmphasis attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textOutline">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e481" id="assert-d1e481-1"
                test="count(subcheck:remove_ttml_color_components(tokenize(normalize-space(.), ' '))) eq 1">The tts:textOutline attribute contains only one value.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-5"
                test="not(contains(., '-'))">The tts:textOutline attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-5"
                test="not(contains(., '-'))">The tts:textOutline attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textShadow">
            <sch:let name="regex_shadow" value="concat($regex_length_ttml2, ' ', $regex_length_ttml2, '( ', $regex_length_ttml2_non_negative, ')?( ', $regex_ttml_color, ')?')"/>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c123" id="assert-w0ab1b7c123-1"
                test="matches(normalize-space(.), concat('^(none|', $regex_shadow, '( ?, ?', $regex_shadow, '){0,3})$'))">
                The tts:textShadow attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:unicodeBidi">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c107" id="assert-w0ab1b7c107-1"
                test="normalize-space(.) = ('normal', 'embed', 'bidiOverride')">The tts:unicodeBidi attribute has one of the following values: 'normal', 'embed', 'bidiOverride'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-6"
                test="not(contains(., '-'))">The tts:extent attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-6"
                test="not(contains(., '-'))">The tts:extent attribute does not contain negative lengths.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:aspectRatio">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1770" id="assert-d1e1770-1"
                test="matches(normalize-space(.), $regex_display_aspect_ratio)">
                The ittp:aspectRatio attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::itts:forcedDisplay">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1987" id="assert-d1e1987-1"
                test="normalize-space(.) = ('true', 'false')">The itts:forcedDisplay attribute has one of the following values: 'true', 'false'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:progressivelyDecodable">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1933" id="assert-d1e1933-1"
                test="normalize-space(.) = ('true', 'false')">The ittp:progressivelyDecodable attribute has one of the following values: 'true', 'false'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ittp:activeArea">
            <sch:let name="values" value="tokenize(normalize-space(.), ' ')"/>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c81Aa" id="assert-w0ab1b7c81Aa-1"
                test="(count($values) eq 4) and (every $x in $values satisfies (subcheck:string_to_amount($x) ge 0 and subcheck:string_to_amount($x) le 100 and subcheck:string_to_unit($x) eq '%'))">
                The ittp:activeArea attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::itts:fillLineGap">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c85Aa" id="assert-w0ab1b7c85Aa-1"
                test="normalize-space(.) = ('true', 'false')">The itts:fillLineGap attribute has one of the following values: 'true', 'false'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ebutts:linePadding">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287" id="assert-d1e287-7"
                test="not(contains(., '-'))">The ebutts:linePadding attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e287a" id="assert-d1e287a-7"
                test="not(contains(., '-'))">The ebutts:linePadding attribute does not contain negative lengths.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e2369" id="assert-d1e2369-1"
                test="matches(normalize-space(.), '^(\d*\.)?\d+c$')">The ebutts:linePadding attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ebutts:multiRowAlign">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e2424" id="assert-d1e2424-1"
                test="normalize-space(.) = ('start', 'center', 'end', 'auto')">The ebutts:multiRowAlign attribute has one of the following values: 'start', 'center', 'end', 'auto'</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERNS test for the correctness of attribute value units -->
    <!--                                                                 -->
    <sch:pattern id="attributeUnits1">
        <sch:rule context="attribute::tts:origin">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1281" id="assert-d1e1281-1"
                test="(normalize-space(.) eq 'auto') or (every $x in subcheck:string_to_units(.) satisfies $x = ('px', '%'))">
                The tts:origin attribute uses the following units only: 'px', '%'</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366" id="assert-d1e1366-1"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:origin attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-1"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:origin attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-5"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:origin attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-5"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:origin attribute does not use the 'c' unit.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent[parent::tt:tt]">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b5c51" id="assert-w0ab1b5c51-1"
                test="every $x in subcheck:string_to_units(.) satisfies $x eq 'px'">
                The tts:extent attribute on tt:tt uses the following unit only: 'px'</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:extent[not(parent::tt:tt)]"><!-- affects tt:region, but can also occur on other elements -->
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c89" id="assert-w0ab1b7c89-1"
                test="every $x in subcheck:string_to_units(.) satisfies $x = ('px', '%')">
                The tts:extent attribute on tt:region uses the following units only: 'px', '%'</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c89a" id="assert-w0ab1b7c89a-1"
                test="every $x in subcheck:string_to_units(.) satisfies $x = ('px', '%', 'rw', 'rh')">
                The tts:extent attribute on tt:region uses the following units only: 'px', '%', 'rw', 'rh'</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366" id="assert-d1e1366-2"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:extent attribute on tt:region uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-2"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:extent attribute on tt:region uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:disparity">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-7"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:disparity attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-7"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:disparity attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:fontSize">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-1"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:fontSize attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-1"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:fontSize attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366" id="assert-d1e1366-3"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:fontSize attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-3"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:fontSize attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:lineHeight">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-2"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:lineHeight attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-2"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:lineHeight attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366" id="assert-d1e1366-4"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:lineHeight attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-4"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:lineHeight attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:padding">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-3"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:padding attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-3"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:padding attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366" id="assert-d1e1366-5"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:padding attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-5"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:padding attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:position">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1282" id="assert-d1e1282-1"
                test="every $x in subcheck:string_to_units(replace(., 'center|left|right|top|bottom', '')) satisfies $x = ('px', '%', 'rw', 'rh')">
                The tts:position attribute uses the following units only: 'px', '%', 'rw', 'rh'</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-8"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:position attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-8"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:position attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:rubyReserve">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-9"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:rubyReserve attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-9"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:rubyReserve attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textOutline">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-4"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:textOutline attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-4"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:textOutline attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366" id="assert-d1e1366-6"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:textOutline attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-6"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:textOutline attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::tts:textShadow">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-10"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:textShadow attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1366a" id="assert-d1e1366a-10"
                test="not(subcheck:string_to_units(.) = 'px') or (/tt:tt/@tts:extent ne '')">
                If a tts:textShadow attribute uses the 'px' unit, the tts:extent on the tt:tt element is set.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::ebutts:linePadding">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e1241" id="assert-d1e1241-1"
                test="not(subcheck:string_to_units(.) = 'c') or (/tt:tt/@ttp:cellResolution ne '')">
                If an ebutts:linePadding attribute uses the 'c' unit, the ttp:cellResolution on the tt:tt element is set.</sch:assert>
            <!-- no check for d1e1366 here, as for ebutts:linePadding anyway only the 'c' unit is allowed! -->
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="attributeUnits2">
        <sch:rule context="attribute::tts:extent">
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260" id="assert-d1e260-6"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:extent attribute does not use the 'c' unit.</sch:assert>
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/d1e260a" id="assert-d1e260a-6"
                test="not(subcheck:string_to_units(.) = 'c')">
                The tts:extent attribute does not use the 'c' unit.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests the timing information attributes in general -->
    <!--                                                                 -->
    <sch:pattern id="attributeTimingGeneral">
        <sch:rule context="/tt:tt">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/d1e1488" id="assert-d1e1488-1"
                test="
                count(
                    distinct-values(
                        for $x
                        in (//attribute::begin[. ne ''] | //attribute::dur[. ne ''] | //attribute::end[. ne ''])
                        return subcheck:time_expression_to_format($x)
                    )
                ) le 1
                ">All time expressions in a document should use the same syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::begin[parent::tt:*]"><!-- check for TTML NS parent, as attribute itself has no namespace -->
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c97" id="assert-w0ab1b7c97-1"
                test="subcheck:timecode_valid(., /tt:tt, false())">
                The begin attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::end[parent::tt:*]"><!-- check for TTML NS parent, as attribute itself has no namespace -->
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c98" id="assert-w0ab1b7c98-1"
                test="subcheck:timecode_valid(., /tt:tt, false())">
                The end attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
        <sch:rule context="attribute::dur[parent::tt:*]"><!-- check for TTML NS parent, as attribute itself has no namespace -->
            <sch:assert diagnostics="attributeValue"
                see="http://www.irt.de/subcheck/constraints/w0ab1b7c99" id="assert-w0ab1b7c99-1"
                test="subcheck:timecode_valid(., /tt:tt, false())">
                The dur attribute value conforms to the defined syntax.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests the timing information attributes in case no ttp:frameRate is set -->
    <!--                                                                                      -->
    <sch:pattern id="attributeTimingFrameRate">
        <sch:rule context="/tt:tt[not(@ttp:frameRate ne '')]">
            <sch:assert diagnostics="beginValueFrameRate"
                see="http://www.irt.de/subcheck/constraints/d1e1408" id="assert-d1e1408-1"
                test="not(//attribute::begin[matches(normalize-space(.), $regex_frames)])">
                If a begin attribute uses the frames unit, the ttp:frameRate on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="durValueFrameRate"
                see="http://www.irt.de/subcheck/constraints/d1e1408" id="assert-d1e1408-2"
                test="not(//attribute::dur[matches(normalize-space(.), $regex_frames)])">
                If a dur attribute uses the frames unit, the ttp:frameRate on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="endValueFrameRate"
                see="http://www.irt.de/subcheck/constraints/d1e1408" id="assert-d1e1408-3"
                test="not(//attribute::end[matches(normalize-space(.), $regex_frames)])">
                If an end attribute uses the frames unit, the ttp:frameRate on the tt:tt element is set.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests the timing information attributes in case no ttp:tickRate is set -->
    <!--                                                                                     -->
    <sch:pattern id="attributeTimingTickRate">
        <sch:rule context="/tt:tt[not(@ttp:tickRate ne '')]">
            <sch:assert diagnostics="beginValueTickRate"
                see="http://www.irt.de/subcheck/constraints/d1e1448" id="assert-d1e1448-1"
                test="not(//attribute::begin[matches(normalize-space(.), $regex_ticks)])">
                If a begin attribute uses the ticks unit, the ttp:tickRate on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="durValueTickRate"
                see="http://www.irt.de/subcheck/constraints/d1e1448" id="assert-d1e1448-2"
                test="not(//attribute::dur[matches(normalize-space(.), $regex_ticks)])">
                If a dur attribute uses the ticks unit, the ttp:tickRate on the tt:tt element is set.</sch:assert>
            <sch:assert diagnostics="endValueTickRate"
                see="http://www.irt.de/subcheck/constraints/d1e1448" id="assert-d1e1448-3"
                test="not(//attribute::end[matches(normalize-space(.), $regex_ticks)])">
                If an end attribute uses the ticks unit, the ttp:tickRate on the tt:tt element is set.</sch:assert>
        </sch:rule>
    </sch:pattern>



    <!-- This PATTERN tests the Netflix constraints related to text paragraphs -->
    <!--                                                                       -->
    <sch:pattern id="netflixTextParagraphs">
        <sch:rule context="tt:p">
            <sch:let name="normalizedText" value="normalize-space(.)"/>
            <sch:let name="testedGlyphText" value="subcheck:checkNetflixGlyphs($normalizedText)"/>
            <sch:assert diagnostics="usedLines"
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d219" id="assert-w0ab1b5d219-1"
                test="subcheck:count_used_lines(.) le 2">
                A subtitle uses at most two lines.
            </sch:assert>
            <sch:assert test="empty($testedGlyphText/unsupported)" diagnostics="unsupportedGlyphs"  see="http://www.irt.de/subcheck/constraints/w0ab1b7d153" id="assert-w0ab1b7d153-1">
                A subtitle contains only glyphs from the NETFLIX Glyph List (version 2).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests the Netflix constraints related to timing (currently valid on tt:p only) -->
    <!--                                                                                             -->
    <sch:pattern id="netflixTiming">
        <sch:rule context="/tt:tt">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d229" id="assert-w0ab1b5d229-1"
                test="attribute::ttp:frameRate">
                The ttp:frameRate attribute is present on the tt:tt element.
            </sch:assert>
        </sch:rule>
        <sch:rule context="tt:p">
            <sch:assert diagnostics="subtitleDuration"
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d209" id="assert-w0ab1b5d209-1"
                test="every $duration in subcheck:subtitle_duration_secs(.) satisfies $duration ge (5 div 6)">
                The duration of a subtitle is at least 5/6 seconds.
            </sch:assert>
            <sch:assert diagnostics="subtitleDuration"
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d211" id="assert-w0ab1b5d211-1"
                test="every $duration in subcheck:subtitle_duration_secs(.) satisfies $duration le 7">
                The duration of a subtitle is at most 7 seconds.
            </sch:assert>
            <sch:assert diagnostics="subtitleGap"
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d213" id="assert-w0ab1b5d213-1"
                test="not(root()/tt:tt/@ttp:frameRate) or not(following-sibling::tt:p) or (
                    every $gap in subcheck:subtitle_gap_frames(.) satisfies $gap ge 2
                )">
                The gap between two adjacent subtitles is at least two frames.
            </sch:assert>
            <sch:assert diagnostics="negativeSubtitleBeginDelta"
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d216" id="assert-w0ab1b5d216-1"
                test="not(following-sibling::tt:p) or (
                    every $begin_delta in subcheck:subtitle_begin_delta_secs(.) satisfies $begin_delta ge 0
                )">
                It is good practice to have linearly increasing timecodes.
            </sch:assert>
        </sch:rule>
        <sch:rule context="tt:region[@begin or @dur or @end][1]">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d230" id="assert-w0ab1b5d230-1"
                test="false()">
                No timing is present immediately on tt:region elements.
            </sch:assert>
        </sch:rule>
        <sch:rule context="tt:body[@begin or @dur or @end][1]">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d230" id="assert-w0ab1b5d230-2"
                test="false()">
                No timing is present immediately on tt:body elements.
            </sch:assert>
        </sch:rule>
        <sch:rule context="tt:div[@begin or @dur or @end][1]">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d230" id="assert-w0ab1b5d230-3"
                test="false()">
                No timing is present immediately on tt:div elements.
            </sch:assert>
        </sch:rule>
        <sch:rule context="tt:span[@begin or @dur or @end][1]">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d230" id="assert-w0ab1b5d230-4"
                test="false()">
                No timing is present immediately on tt:span elements.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- This PATTERN tests generic Netflix aspects e.g. the document encoding -->
    <!--                                                                       -->
    <sch:pattern id="netflixGeneric">
        <sch:rule context="/">
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests the Netflix constraints related to styling on tt:p -->
    <!--                                                                       -->
    <sch:pattern id="netflixStylingParagraph">
        <sch:rule context="tt:p">
            <sch:assert see="http://www.irt.de/subcheck/constraints/w0ab1b5d217" id="assert-w0ab1b5d217-1"
                test="normalize-space(subcheck:get_style_property(., xs:QName('tts:textAlign'), true(), (), '', false())) ne ''">
                The tts:textAlign attribute is used for horizontal alignment of subtitles.
            </sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- This PATTERN tests the Netflix constraints related to styling affecting content elements -->
    <!--                                                                                          -->
    <sch:pattern id="netflixStylingContent">
        <sch:rule context="tt:p[normalize-space(string-join(child::text(), '')) ne ''] | tt:span">
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d220" id="assert-w0ab1b5d220-1"
                test="normalize-space(subcheck:get_style_property(., xs:QName('tts:displayAlign'), false(), xs:QName('tt:region'), '', false())) ne ''">
                The tts:displayAlign attribute is used for vertical alignment of subtitles.
            </sch:assert>
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d221" id="assert-w0ab1b5d221-1"
                test="normalize-space(subcheck:get_style_property(., xs:QName('tts:origin'), false(), xs:QName('tt:region'), '', false())) ne ''">
                The tts:origin attribute is used for subtitle positioning.
            </sch:assert>
            <sch:assert
                see="http://www.irt.de/subcheck/constraints/w0ab1b5d223" id="assert-w0ab1b5d223-1"
                test="normalize-space(subcheck:get_style_property(., xs:QName('tts:extent'), false(), xs:QName('tt:region'), '', false())) ne ''">
                The tts:extent attribute is used for subtitle positioning.
            </sch:assert>
            <sch:let name="default_value_constant" value="'VALUE_CONSTANT_THAT_SHOULD NEVER_OCCUR_AND_IS_USED_TO_CHECK_FOR_NO_PRESENCE_OF_STYLE_VALUE'"/>
            <sch:assert see="http://www.irt.de/subcheck/constraints/w0ab1b5d225" id="assert-w0ab1b5d225-1"
                test="normalize-space(subcheck:get_style_property(., xs:QName('tts:fontSize'), true(), (), $default_value_constant, false())) ne $default_value_constant">
                The tts:fontSize attribute is present.
            </sch:assert>
            <sch:assert see="http://www.irt.de/subcheck/constraints/w0ab1b5d227" id="assert-w0ab1b5d227-1"
                test="normalize-space(subcheck:get_style_property(., xs:QName('tts:fontSize'), true(), (), '1c', false())) eq '100%'">
                The tts:fontSize attribute is set to "100%".
            </sch:assert>
        </sch:rule>
    </sch:pattern>


    <!--###########
        diagnostics
        ###########-->
    <sch:diagnostics>
        <sch:diagnostic id="documentEncoding">The current document encoding is '<sch:value-of select="subcheck:document_encoding(.)"/>'.</sch:diagnostic>
        <sch:diagnostic id="elementChildOf">The element
            '<sch:value-of select="name()"/>' is a child of the element '<sch:value-of
                select="parent::*/name()"/>'.</sch:diagnostic>
        <sch:diagnostic id="attributeDefinedOn">The attribute
                '<sch:value-of select="name()"/>' appears on the element '<sch:value-of
                select="parent::*/name()"/>'.
            <!-- also output the parent element name if the attribute is specified on tt:set, as its parent matters -->
            <sch:value-of select="if(parent::tt:set) then concat('This element itself is child of the element ''', parent::*/parent::*/name() ,'''.') else ''"/>
        </sch:diagnostic>
        <sch:diagnostic id="attributeValue">The value of the attribute '<sch:value-of select="name()"/>' is '<sch:value-of
                select="."/>'.</sch:diagnostic>
        <sch:diagnostic id="beginValueFrameRate">The framerate is not specified and at least one begin attribute uses frames (e.g.
            '<sch:value-of select="//attribute::begin[matches(normalize-space(.), $regex_frames)][1]"/>').</sch:diagnostic>
        <sch:diagnostic id="durValueFrameRate">The framerate is not specified and at least one dur attribute uses frames (e.g.
            '<sch:value-of select="//attribute::dur[matches(normalize-space(.), $regex_frames)][1]"/>').</sch:diagnostic>
        <sch:diagnostic id="endValueFrameRate">The framerate is not specified and at least one end attribute value uses frames (e.g.
            '<sch:value-of select="//attribute::end[matches(normalize-space(.), $regex_frames)][1]"/>').</sch:diagnostic>
        <sch:diagnostic id="beginValueTickRate">The tickrate is not specified and at least one begin attribute uses ticks (e.g.
            '<sch:value-of select="//attribute::begin[matches(normalize-space(.), $regex_ticks)][1]"/>').</sch:diagnostic>
        <sch:diagnostic id="durValueTickRate">The tickrate is not specified and at least one dur attribute uses ticks (e.g.
            '<sch:value-of select="//attribute::dur[matches(normalize-space(.), $regex_ticks)][1]"/>').</sch:diagnostic>
        <sch:diagnostic id="endValueTickRate">The tickrate is not specified and at least one end attribute uses ticks (e.g.
            '<sch:value-of select="//attribute::end[matches(normalize-space(.), $regex_ticks)][1]"/>').</sch:diagnostic>
        <sch:diagnostic id="usedLines">The subtitle uses <sch:value-of select="subcheck:count_used_lines(.)"/> line(s).</sch:diagnostic>
        <sch:diagnostic id="subtitleDuration">The duration of the subtitle is <sch:value-of select="subcheck:subtitle_duration_secs(.)"/> second(s).</sch:diagnostic>
        <!-- as the gap check (that uses the following diagnostics) is only executed if @ttp:frameRate is present, the attribute value can be used in the calculation without further presence check -->
        <sch:diagnostic id="subtitleGap">The gap between the current and the following subtitle is <sch:value-of select="subcheck:subtitle_gap_frames(.)"/> frame(s)
            given a frame rate of <sch:value-of select="number(root()/tt:tt/@ttp:frameRate)"/> fps.</sch:diagnostic>
        <sch:diagnostic id="elementId">The affected '<sch:value-of select="name()"/>' element has the ID '<sch:value-of select="@xml:id"/>'.</sch:diagnostic>
        <sch:diagnostic id="negativeSubtitleBeginDelta">The following subtitle starts <sch:value-of select="-1 * subcheck:subtitle_begin_delta_secs(.)"/> second(s) earlier than the current one.</sch:diagnostic>
        <sch:diagnostic id="unsupportedGlyphs">The unsupported glyphs in the subtitle text are enclosed in '*' with the numeric HTML entity in '( )': <sch:value-of select="$testedGlyphText"/>.</sch:diagnostic>        
    </sch:diagnostics>
</sch:schema>