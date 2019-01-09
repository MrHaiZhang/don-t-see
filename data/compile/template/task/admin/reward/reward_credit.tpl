<!--=============积分奖励===============-->
<tbody class="J_reward_forum">
	<tr>
		<th>积分名称</th>
		<td>
			<span class="must_red">*</span>
			<input type="hidden" value="id-name-unit" name="reward[key]" />
			<select class="select_5" name="reward[value]">
	<?php foreach ($credit->cType as $id => $item) {
			$_tmp = $id . '-' . $item . '-' . $credit->cUnit[$id];
	?>
			<option value="<?php echo htmlspecialchars($_tmp, ENT_QUOTES, 'UTF-8');?>" <?php echo htmlspecialchars(Pw::isSelected($_tmp == $reward['value']), ENT_QUOTES, 'UTF-8');?>><?php echo htmlspecialchars($item, ENT_QUOTES, 'UTF-8');?></option>
	<?php }?>
			</select>
		</td>
		<td><div class="fun_tips"></div></td>
	</tr>
	<tr>
		<th>积分数量</th>
		<td>
			<span class="must_red">*</span>
			<input type="text" class="input length_5 mr5" name="reward[num]" value="<?php echo htmlspecialchars($reward['num'], ENT_QUOTES, 'UTF-8');?>">
			<input type="hidden" value="{num}{unit}{name}" name="reward[descript]" />
		</td>
		<td><div class="fun_tips"></div></td>
	</tr>
</tbody>
