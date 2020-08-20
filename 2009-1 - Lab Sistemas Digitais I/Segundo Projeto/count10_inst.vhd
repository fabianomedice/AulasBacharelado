count10_inst : count10 PORT MAP (
		aclr	 => aclr_sig,
		aload	 => aload_sig,
		clock	 => clock_sig,
		cnt_en	 => cnt_en_sig,
		data	 => data_sig,
		cout	 => cout_sig,
		q	 => q_sig
	);
