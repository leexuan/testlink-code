{* TestLink Open Source Project - http://testlink.sourceforge.net/ *}
{* $Id: execNavigator.tpl,v 1.16 2008/10/07 16:46:22 havlat Exp $ *}
{* Purpose: smarty template - show test set tree *}
{*
rev :
     20080621 - franciscom - adding ext js treemenu
     20080427 - franciscom - refactoring
     20080224 - franciscom - BUGID 1056
     20070225 - franciscom - fixed auto-bug BUGID 642
     20070212 - franciscom - name changes on html inputs
                             use input_dimensions.conf

*}
{lang_get var="labels"
          s="filter_result,caption_nav_filter_settings,filter_owner,
             btn_apply_filter,build,keyword,filter_tcID,include_unassigned_testcases,priority"}
       
       
{assign var="keywordsFilterDisplayStyle" value=""}
{if $gui->keywordsFilterItemQty == 0}
    {assign var="keywordsFilterDisplayStyle" value="display:none;"}
{/if}

{* ===================================================================== *}
{include file="inc_head.tpl" openHead="yes"}
{if $smarty.const.USE_EXT_JS_LIBRARY || $tlCfg->treemenu_type == 'EXTJS'}
    {include file="inc_ext_js.tpl"}
{/if}
          
{if $tlCfg->treemenu_type == 'EXTJS'}
    {literal}
    <script type="text/javascript">
    treeCfg = {tree_div_id:'tree',root_name:"",root_id:0,root_href:"",
               loader:"", enableDD:false, dragDropBackEndUrl:'',children:""};
    </script>
    {/literal}
    
    <script type="text/javascript">
    treeCfg.root_name='{$gui->ajaxTree->root_node->name|escape:'javascript'}';
    treeCfg.root_id={$gui->ajaxTree->root_node->id};
    treeCfg.root_href='{$gui->ajaxTree->root_node->href}';
    treeCfg.children={$gui->ajaxTree->children};
    </script>
    
    <script type="text/javascript" src='gui/javascript/execTree.js'></script>
{else}
   	{include file="inc_jsTree.tpl"}
{/if}

<script language="JavaScript" src="gui/javascript/expandAndCollapseFunctions.js" type="text/javascript"></script>
</head>

{* ===================================================================== *}
<body onLoad="show_hide('tplan_settings','tpn_view_settings',0);">
{assign var="cfg_section" value=$smarty.template|basename|replace:".tpl":"" }
{assign var="build_number" value=$gui->optBuildSelected }
{config_load file="input_dimensions.conf" section=$cfg_section}

<h1 class="title">{lang_get s='TestPlan'}{$tlCfg->gui_title_separator_1} {$gui->tplan_name|escape}
{$tlCfg->gui_separator_open}{$labels.build}{$tlCfg->gui_title_separator_1}
{$gui->optBuild.$build_number}{$tlCfg->gui_separator_close}</h1>

<input type='hidden' id="tpn_view_settings"
         name="tpn_view_status"  value="0" />
<div class="x-panel-header x-unselectable">
	<div class="x-tool x-tool-toggle" style="background-position:0 -75px; float:left;"
		onclick="show_hide('tplan_settings', 'tpn_view_settings',
	              document.getElementById('tplan_settings').style.display=='none')">
	</div>
	<span style="padding:2px;">{$labels.caption_nav_filter_settings} {include file="inc_help.tpl" helptopic="hlp_executeFilter"}</span>
</div>

<div id="tplan_settings" class="exec_additional_info" style="margin: 3px;">
<form method="post">
	<table class="smallGrey" width="100%">
		<caption>
			{$labels.caption_nav_filter_settings}
			
		</caption>
		<tr>
			<td>{$labels.build}</td>
			<td><select name="build_id">
				{html_options options=$gui->optBuild selected=$gui->optBuildSelected}
				</select>
			</td>
		</tr>
		<tr>
			<td>{$labels.filter_tcID}</td>
			<td><input type="text" name="targetTestCase" value="{$gui->targetTestCase}" 
			           maxlength="{#TC_ID_MAXLEN#}" size="{#TC_ID_SIZE#}"/></td>
		</tr>
		<tr style="{$keywordsFilterDisplayStyle}">
			<td>{$labels.keyword}</td>
			<td><select name="keyword_id[]" multiple="multiple" size={$gui->keywordsFilterItemQty}>
			    {html_options options=$gui->keywords_map selected=$gui->keyword_id}
				</select>
			</td>
		</tr>
		<tr>
			<td>{$labels.priority}</td>
			<td><select name="urgencyImportance">
				<option value=""/>{$gui->str_option_any}</option>
				{html_options options=$gsmarty_option_importance selected=$gui->urgencyImportance}
				</select>
			</td>
		</tr>
		<tr>
				<td>{$labels.filter_result}</td>
			<td>
			  <select name="filter_status">
			  {html_options options=$gui->optResult selected=$gui->optResultSelected}
			  </select>
			</td>
		</tr>
		<tr>
			<td>{$labels.filter_owner}</td>
			<td>
 			{if $gui->disable_filter_assigned_to}
			  {$gui->assigned_to_user}
			{else}
				<select name="filter_assigned_to">
					{html_options options=$gui->users selected=$gui->filter_assigned_to}
				</select>
			{/if}
			</td>
		</tr>
  	<tr>
   		<td>{$labels.include_unassigned_testcases}</td>
  		<td>
  		   <input type="checkbox"
  		           id="include_unassigned" name="include_unassigned"
  		           value="1"
  		           {if $gui->include_unassigned} checked="checked" {/if} />
  		</td>
  	</tr>
        	{$gui->design_time_cfields}
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="submitOptions" value="{$labels.btn_apply_filter}" style="font-size: 90%;" /></td>
		</tr>
	</table>
</form>
</div>


{* ===================================================================== *}
{if $tlCfg->treemenu_type == 'EXTJS'}    
    <div id="tree" style="overflow:auto; height:400px;border:1px solid #c3daf9;"></div>
{else}
    <div class="tree" id="tree">
    {$gui->tree}
    </div>
{/if}

{if $gui->src_workframe != ''}
<script type="text/javascript">
	parent.workframe.location='{$gui->src_workframe}';
</script>
{/if}

</body>
</html>
