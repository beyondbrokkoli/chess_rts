alias zramstat='echo -e "Orig_Data(B) Compr_Data(B) Mem_Total(B) Mem_Limit(B) Max_Used(B) Same_Pages Pages_Compacted Huge_Pages Huge_Pages_Since\n$(cat /sys/block/zram0/mm_stat)" | column -t'
