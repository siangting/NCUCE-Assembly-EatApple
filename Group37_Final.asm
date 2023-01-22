TITLE example of ASM                (asmExample.ASM)

INCLUDE Irvine32.inc
INCLUDE Macros.inc
 
main EQU start@0

.data

Start_Delay DWORD 300	;開始畫面更新速度
Delay_FPS DWORD    40	;遊戲畫面更新速度
Delay_Die DWORD  1500	;結束畫面更新速度

BCol BYTE 70			; 螢幕寬度
BRow BYTE 27			; 螢幕高度

;分數設定
Score WORD 0
ScoreName BYTE "score : ",0
ScoreX BYTE 75 
ScoreY BYTE 5  


;標題字串
START0 BYTE  "                                                                                                 " ,0
START1 BYTE  "                                                                                            /    " ,0
START2 BYTE  "             ______     __    _______      __     _____    _____    _        ______     ___/___  " ,0
START3 BYTE  "            |  ____|   /  \  |__   __|    /  \   |  __ \  |  __ \  | |      |  ____|   /       \ " ,0
START4 BYTE  "            | |____   / /\ \    | |      / /\ \  | |__\ \ | |__\ \ | |      | |____   |         |" ,0
START5 BYTE  "            |  ____| / /__\ \   | |     / /__\ \ |  ____/ |  ____/ | |      |  ____|  |         |" ,0
START6 BYTE  "            | |____  |  __  |   | |     |  __  | | |      | |      | |____  | |____   |         |" ,0
START7 BYTE  "            |______| |_|  |_|   |_|     |_|  |_| |_|      |_|      |______| |______|   \_______/ " ,0
;標題字串更新
START3_Bite BYTE  "            |  ____|   /  \  |__   __|    /  \   |  __ \  |  __ \  | |      |  ____|   /       / " ,0
START4_Bite BYTE  "            | |____   / /\ \    | |      / /\ \  | |__\ \ | |__\ \ | |      | |____   |       /  " ,0
START5_Bite BYTE  "            |  ____| / /__\ \   | |     / /__\ \ |  ____/ |  ____/ | |      |  ____|  |       \  " ,0
START6_Bite BYTE  "            | |____  |  __  |   | |     |  __  | | |      | |      | |____  | |____   |        \ " ,0
START7_Bite BYTE  "            |______| |_|  |_|   |_|     |_|  |_| |_|      |_|      |______| |______|   \_______/ " ,0



;標題字串
PressToStart1 BYTE "                    Press left and right to move your dinosaur and eat good apple." ,0
PressToStart2 BYTE "                    If you eat bad apple, game will over.                         " ,0
PressToStart3 BYTE "                    Press space to start. Press ESC to end game.                  " ,0

;遊戲結束字串
GG1 Byte "                      __   _   _  _ ___    _      ___ __ ",0
GG2 Byte "                     / _  /_\  |\/| |_    / \ | / |_  |_)",0
GG3 Byte "                     \__/ |  \ |  | |__   \_/ \/  |__ | \",0

;螢幕清除字串
ClearStr BYTE "                                                                  ",0

;牆壁
Map1 BYTE "| ",0
Map2 BYTE ". ",0

;好蘋果
Apple1 BYTE "    ",0
Apple2 BYTE " _/_",0
Apple3 BYTE "|  |",0
Apple4 BYTE "----",0

;壞蘋果
Bad_Apple1 BYTE "    ",0
Bad_Apple2 BYTE " _/_",0
Bad_Apple3 BYTE "\__/",0
Bad_Apple4 BYTE "/__\",0

;被消滅的蘋果
No_Apple1 BYTE "    ",0
No_Apple2 BYTE "    ",0
No_Apple3 BYTE "    ",0
No_Apple4 BYTE "    ",0

;障礙物定位
AppleCoordinateX BYTE 11
AppleCoordinateY BYTE 0
;障礙物碰撞座標
AppleCollisionX1 BYTE ?
AppleCollisionX2 BYTE ?
AppleCollisionY1 BYTE 24
AppleCollisionY2 BYTE 28
Apple_height BYTE 3
Apple_width BYTE 3


;吃蘋果恐龍
Eat1_1 BYTE "      ____      ",0
Eat1_2 BYTE "    /   U  \    ",0
Eat1_3 BYTE "   |\______/|   ",0
Eat1_4 BYTE "   |  _  _  |   ",0
Eat1_5 BYTE "   |________|   ",0

Eat2_1 BYTE "                ",0
Eat2_2 BYTE "    ________    ",0
Eat2_3 BYTE "   |\______/|   ",0
Eat2_4 BYTE "   |  _  _  |   ",0
Eat2_5 BYTE "   |________|   ",0

Eat3_1 BYTE "     _______    ",0
Eat3_2 BYTE "    /  /    \   ",0
Eat3_3 BYTE "   |   \____/   ",0
Eat3_4 BYTE "   |  _  _  |   ",0
Eat3_5 BYTE "   |________|   ",0

Eat4_1 BYTE "    _______     ",0
Eat4_2 BYTE "   /    \  \    ",0
Eat4_3 BYTE "   \____/   |   ",0
Eat4_4 BYTE "   |  _  _  |   ",0
Eat4_5 BYTE "   |________|   ",0


;恐龍定位
EatCoordinateX BYTE 10
EatCoordinateY BYTE 24
;恐龍吃到蘋果座標
EatAppleX1 BYTE ?
EatAppleX2 BYTE ?
EatAppleY1 BYTE 24
EatAppleY2 BYTE 28
Eat_height BYTE 4
Eat_width BYTE 11

;恐龍口水
Spit1 BYTE " /\ ",0
Spit2 BYTE "/__\",0

;口水定位
SpitCoordinateX BYTE ?
SpitCoordinateY1 BYTE ?
SpitCoordinateY2 BYTE ?
Spit_width BYTE 4

;Flag
MapFlag BYTE 0
GameoverFlag BYTE 0
AnimateFlag BYTE 0
AppleFlag BYTE 0
SpitFlag BYTE 0
EliminateFlag BYTE 0

;隨機變數
randVal   DWORD    ?


.code

;在指定座標添加字串
Create_str PROC USES eax ebx ecx edx,
    pStr:PTR BYTE,	;字串指標
    column: BYTE,	;座標x
    row: BYTE		;座標y
    mov  dl,column
    mov  dh,row
    call Gotoxy
	mov eax, white+(black*16)	; Set text color to white on black
    call SetTextColor
	mov edx,pStr
	call Writestring
    ret
Create_str ENDP

;在指定座標添加整數
Create_int PROC USES eax ebx ecx edx,
    column: BYTE,	;座標x
    row: BYTE		;座標y
    mov  dl,column
    mov  dh,row
    call Gotoxy
	mov eax, white+(black*16)	; Set text color to white on black
    call SetTextColor
	movzx eax,score
	call WriteDec
    ret
Create_int ENDP

;顯示開頭動畫
title_Animate PROC
	mov bl,AnimateFlag
	.IF bl == 0	
        INVOKE Create_str ,OFFSET START1,2,7
       	INVOKE Create_str ,OFFSET START2,2,8
        INVOKE Create_str ,OFFSET START3,2,9
      	INVOKE Create_str ,OFFSET START4,2,10
		INVOKE Create_str ,OFFSET START5,2,11
		INVOKE Create_str ,OFFSET START6,2,12
		INVOKE Create_str ,OFFSET START7,2,13
		INVOKE Create_str ,OFFSET START0,2,14
		INVOKE Create_str ,OFFSET START0,2,20
		INVOKE Create_str ,OFFSET START0,2,21
		INVOKE Create_str ,OFFSET START0,2,22
	.ELSE
		INVOKE Create_str ,OFFSET START0,2,5
		INVOKE Create_str ,OFFSET START0,2,7
       	INVOKE Create_str ,OFFSET START1,2,8
    	INVOKE Create_str ,OFFSET START2,2,9
    	INVOKE Create_str ,OFFSET START3_Bite,2,10
      	INVOKE Create_str ,OFFSET START4_Bite,2,11
		INVOKE Create_str ,OFFSET START5_Bite,2,12
		INVOKE Create_str ,OFFSET START6_Bite,2,13
		INVOKE Create_str ,OFFSET START7_Bite,2,14
		
	.ENDIF
	INVOKE Create_str ,OFFSET PressToStart1,2,20
	INVOKE Create_str ,OFFSET PressToStart2,2,21
	INVOKE Create_str ,OFFSET PressToStart3,2,22
	xor bl,1b ;若bl = 0 設 1 ， = 1 設 0
	mov AnimateFlag,bl
	ret
title_Animate ENDP

;印出開始畫面
eatStart PROC USES eax ebx ecx edx
    INVOKE Create_str ,OFFSET START1,2,8
    INVOKE Create_str ,OFFSET START2,2,9
    INVOKE Create_str ,OFFSET START3,2,10
    INVOKE Create_str ,OFFSET START4,2,11
    INVOKE Create_str ,OFFSET START5,2,12
    INVOKE Create_str ,OFFSET START6,2,13
	INVOKE Create_str ,OFFSET START7,2,14
    INVOKE Create_str ,OFFSET PressToStart1,2,20
    INVOKE Create_str ,OFFSET PressToStart2,2,21
    INVOKE Create_str ,OFFSET PressToStart3,2,22
;按space開始遊戲
    checkspace:
        call Readkey
        .IF dx == 20h ;if space is pressed
            call Clrscr
            ret
		.ELSEIF dx == 1Bh ;if ESC is pressed
             exit
            ret
        .ENDIF
        mov ecx , 2
		mov eax, Start_Delay	;螢幕更新速率
		call delay
		call title_Animate		;更新螢幕動畫
		loop checkspace
    ret
eatStart ENDP

;設置地圖
mapBuilid PROC USES eax ebx ecx edx
	movsx ecx,BRow	;地圖寬度
	mov bl,MapFlag
    L1:
		.IF bl == 0	
			INVOKE Create_str ,OFFSET Map1,BCol,cl
		.ELSE
			INVOKE Create_str ,OFFSET Map2,BCol,cl
		.ENDIF
		xor bl,1b 	;若bl = 0 設 1 ， = 1 設 0
	LOOP L1
	xor MapFlag,1b 	;若flag = 0 設 1 ， = 1 設 0
	ret
mapBuilid ENDP

;印出分數
PrintScore PROC USES EAX EBX ECX EDX
	INVOKE Create_str ,OFFSET scoreName,ScoreX,ScoreY
	mov dl,ScoreY
	add dl,2
	INVOKE Create_int ,ScoreX,dl
	ret
PrintScore ENDP

;清除地板
ClearGround PROC USES eax ebx ecx edx
	mov bl,BRow
	INVOKE Create_str ,OFFSET ClearStr,0,bl
	inc bl
	INVOKE Create_str ,OFFSET ClearStr,0,bl
	inc bl
	INVOKE Create_str ,OFFSET ClearStr,0,bl
	inc bl
	INVOKE Create_str ,OFFSET ClearStr,0,bl
	ret
ClearGround ENDP

;生成蘋果(好壞蘋果)
CreateApple PROC USES eax ebx ecx edx
	mov bl,AppleCoordinateY
	.IF EliminateFlag == 1
		
		INVOKE Create_str ,OFFSET No_Apple1,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET No_Apple2,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET No_Apple3,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET No_Apple4,AppleCoordinateX,bl
	.ELSEIF AppleFlag == 0
		INVOKE Create_str ,OFFSET Apple1,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET Apple2,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET Apple3,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET Apple4,AppleCoordinateX,bl
	.ELSE
		INVOKE Create_str ,OFFSET Bad_Apple1,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET Bad_Apple2,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET Bad_Apple3,AppleCoordinateX,bl
		inc bl
		INVOKE Create_str ,OFFSET Bad_Apple4,AppleCoordinateX,bl
	.ENDIF
	ret
CreateApple ENDP

;更新所有座標
XYupdate PROC USES eax ebx ecx edx
	inc AppleCoordinateY			;更新蘋果位置
	mov bl,AppleCoordinateY
	.IF bl >= BRow				;當蘋果到達邊界
		mov EliminateFlag, 0
		call Random32
		and al,00001b			;挑選0.1
		mov AppleFlag, al
		mov AppleCoordinateY,0
		call Random32
		and al,111110b			;挑選從2-62的數字
		mov AppleCoordinateX,al		;移動到隨機位置
		call ClearGround
	.ENDIF
	;設定吃到蘋果的範圍框
	mov dl,AppleCoordinateX
	mov AppleCollisionX1,dl
	mov AppleCollisionX2,dl
	mov dl,Apple_width
	add AppleCollisionX2,dl
	
	mov dl,AppleCoordinateY
	mov AppleCollisionY1,dl
	inc AppleCollisionY1
	mov AppleCollisionY2,dl
	mov dl,Apple_height
	add AppleCollisionY2,dl
	;設定吃蘋果恐龍範圍框
	mov dl,EatCoordinateX
	add dl,2
	mov EatAppleX1,dl
	add dl,Eat_width
	mov EatAppleX2,dl	
	ret
XYupdate ENDP

;更新恐龍位置
Movement PROC
	call ReadKey
		.IF dx == 25h 				;按了向左
			.IF EatCoordinateX > 1	;將座標x增加2
				dec EatCoordinateX
				dec EatCoordinateX
			.ENDIF
			;印出往右恐龍
			INVOKE Create_str ,OFFSET Eat3_1,EatCoordinateX,24
			INVOKE Create_str ,OFFSET Eat3_2,EatCoordinateX,25
			INVOKE Create_str ,OFFSET Eat3_3,EatCoordinateX,26
			INVOKE Create_str ,OFFSET Eat3_4,EatCoordinateX,27
			INVOKE Create_str ,OFFSET Eat3_5,EatCoordinateX,28
		.ELSEIF  dx == 27h 			;按了向右
			mov dl,BCol
			sub dl,16
			.IF EatCoordinateX < dl		;將座標x減少2
				inc EatCoordinateX
				inc EatCoordinateX
			.ENDIF
			;印出往左恐龍
			INVOKE Create_str ,OFFSET Eat4_1,EatCoordinateX,24
			INVOKE Create_str ,OFFSET Eat4_2,EatCoordinateX,25
			INVOKE Create_str ,OFFSET Eat4_3,EatCoordinateX,26
			INVOKE Create_str ,OFFSET Eat4_4,EatCoordinateX,27
			INVOKE Create_str ,OFFSET Eat4_5,EatCoordinateX,28
		.ELSEIF dx == 26h && SpitFlag == 0	;按了向前
			mov SpitFlag, 1
			mov bl, EatCoordinateX
			mov SpitCoordinateX, bl
			add SpitCoordinateX, 5
			mov SpitCoordinateY1, 22
			mov SpitCoordinateY2, 23
		.ELSE
			;印出向前恐龍動畫
			mov bl,AnimateFlag
			.IF bl == 0	
				;印出張嘴恐龍
				INVOKE Create_str ,OFFSET Eat1_1,EatCoordinateX,24
				INVOKE Create_str ,OFFSET Eat1_2,EatCoordinateX,25
				INVOKE Create_str ,OFFSET Eat1_3,EatCoordinateX,26
				INVOKE Create_str ,OFFSET Eat1_4,EatCoordinateX,27
				INVOKE Create_str ,OFFSET Eat1_5,EatCoordinateX,28
			.ELSE
				;印出閉嘴恐龍
				INVOKE Create_str ,OFFSET Eat2_1,EatCoordinateX,24
				INVOKE Create_str ,OFFSET Eat2_2,EatCoordinateX,25
				INVOKE Create_str ,OFFSET Eat2_3,EatCoordinateX,26
				INVOKE Create_str ,OFFSET Eat2_4,EatCoordinateX,27
				INVOKE Create_str ,OFFSET Eat2_5,EatCoordinateX,28
			.ENDIF
			xor bl,1b ;若bl = 0 設 1 ， = 1 設 0
			mov AnimateFlag,bl
		.ENDIF
		ret
Movement ENDP



;死亡
Gameover PROC uses eax edx
	mov eax,Delay_Die	;設定延遲
	call Delay
	;顯示gameover
	INVOKE Create_str ,OFFSET GG1,1,12
	INVOKE Create_str ,OFFSET GG2,1,13
	INVOKE Create_str ,OFFSET GG3,1,14
    call Delay
	;遊戲重置
	mov GameoverFlag,1
	mov AppleCoordinateX,11
	mov AppleCoordinateY,0
	mov EatCoordinateX,10
	mov EatCoordinateY,24
	call XYupdate
	mov score,0
	call Clrscr
	ret
Gameover ENDP

;吃到蘋果
EatApple PROC USES EAX EBX ECX EDX
	mov dl,AppleCollisionX1 
	.IF dl <= EatAppleX2 && dl >= EatAppleX1
		mov dl, AppleCollisionY2 
		.IF dl <= EatAppleY2 && dl >= EatAppleY1
			.IF AppleFlag == 0	;蘋果是好蘋果
				inc score
			.ELSE 			;蘋果是壞蘋果
				call Gameover
			.ENDIF
		.ENDIF
	.ENDIF
	mov dl,AppleCollisionX2
	.IF dl <= EatAppleX2 && dl >= EatAppleX1
		mov dl, AppleCollisionY2 
		.IF dl <= EatAppleY2 && dl >= EatAppleY1
			.IF AppleFlag == 0
				inc score
			.ELSE 
				call Gameover
			.ENDIF
		.ENDIF
	.ENDIF
	ret
EatApple ENDP

;更新口水狀態
EliminateApple PROC
	;消除前口水
	INVOKE Create_str ,OFFSET ClearStr,SpitCoordinateX,SpitCoordinateY1
	INVOKE Create_str ,OFFSET ClearStr,SpitCoordinateX,SpitCoordinateY2
	;貼上新口水
	mov bl, AppleCollisionY2
	.IF SpitCoordinateY1 <= 0
		mov SpitFlag, 0
	.ELSEIF SpitCoordinateY1 < bl
		mov dl, SpitCoordinateX
		mov SpitFlag, 0
		.IF dl >= AppleCollisionX1 && dl <= AppleCollisionX2
			mov EliminateFlag, 1
			;消除口水
			INVOKE Create_str ,OFFSET ClearStr,SpitCoordinateX,SpitCoordinateY1
			INVOKE Create_str ,OFFSET ClearStr,SpitCoordinateX,SpitCoordinateY2
		.ENDIF
	.ELSE
		dec SpitCoordinateY1
		dec SpitCoordinateY1
		dec SpitCoordinateY2
		dec SpitCoordinateY2
		;印出口水
		INVOKE Create_str ,OFFSET Spit1,SpitCoordinateX,SpitCoordinateY1
		INVOKE Create_str ,OFFSET Spit2,SpitCoordinateX,SpitCoordinateY2
	.ENDIF		
	ret
EliminateApple ENDP

main PROC
;開始遊戲
Initial:
	mov GameoverFlag,0
	mov SpitFlag,0
	call eatStart
	call Clrscr
	;進入遊戲
	call mapBuilid
	call CreateApple
    Game:
		call XYupdate
		.IF EliminateFlag == 0
			call EatApple
		.ENDIF
		.IF GameoverFlag == 1	;重置遊戲
			jmp Initial
		.ENDIF
		call PrintScore  	;印分數
		call mapBuilid
		call CreateApple
		call Movement
		.IF SpitFlag == 1
			call EliminateApple
		.ENDIF
            mov eax, Delay_FPS		;螢幕更新速率
	    call delay
		mov ecx,2
    Loop Game
main ENDP
END main