onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 /test_tb/clock
add wave -noupdate -height 30 /test_tb/Pc
add wave -noupdate -height 30 /test_tb/insOutIF
add wave -noupdate -height 30 /test_tb/prePc
add wave -noupdate -height 30 /test_tb/insOutEX
add wave -noupdate -height 30 /test_tb/preJF
add wave -noupdate -height 30 /test_tb/preJIF
add wave -noupdate -height 30 /test_tb/preJEX
add wave -noupdate -height 30 /test_tb/enable
add wave -noupdate -height 30 /test_tb/aluData
add wave -noupdate -height 30 /test_tb/csrData
add wave -noupdate -height 30 /test_tb/Da
add wave -noupdate -height 30 /test_tb/ramDataOut
add wave -noupdate -height 30 /test_tb/ramDataIn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {969975 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {307072 ps}
