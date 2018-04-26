%CDEFTAGS/EXT:1

PROGRAM PeekPoke;

PROCEDURE Poke ( address : INTEGER; value : INTEGER );

BEGIN
    IF (value >= 0) AND (value <= 255) THEN BEGIN
        BYTE[address] := value;
    END;
END;

FUNCTION Peek ( address : INTEGER ) : INTEGER;

BEGIN
    Peek := BYTE[address];
END;

PROCEDURE Sound;

VAR
 intTone, intDuration, intA, Result : Integer;

BEGIN
   WRITELN ('Testing Peek and Poke');
   WRITELN ('Testing Poke by generating sound');
   REPEAT
      BEGIN
         WRITELN ('Enter Tone. Type 0 to exit : ');
         READLN (intTone);
         WRITELN;

         WRITELN ('Enter Duration. Type 0 to exit : ');
         READLN (intDuration);
         WRITELN;

         Poke (140, intTone);
         intA := intDuration * 4;
         Poke (141, intA DIV 256 );
         Poke (142, intA MOD 256 );
         Result := CALL(WORD[43350], 0);
      END;
   UNTIL (intDuration = 0) and (intTone = 0);
   WRITELN ('Finished...');
END;

PROCEDURE PSG_POKE( REG : INTEGER; VALUE : INTEGER);

BEGIN
   Poke ($FF5E,REG);
   Poke ($FF5F,VALUE);
END;

PROCEDURE PSG1;

VAR
 x : INTEGER;
 y : INTEGER;

BEGIN
   PSG_POKE(7,248);
   PSG_POKE(8,15);
   FOR x := 0 to 15 DO BEGIN
       PSG_POKE(1,x);
       FOR y := 0 to 255 DO BEGIN
           PSG_POKE(0,y);
       END;
   END;
   PSG_POKE(7,255);
END;


PROCEDURE PSG2;

VAR
 x : INTEGER;
 y : INTEGER;

BEGIN
   PSG_POKE(7,248);
   PSG_POKE(8,15);
   PSG_POKE(9,15);
   PSG_POKE(10,15);
   FOR x := 0 to 15 DO BEGIN
       PSG_POKE(1,x);
       IF x > 0 THEN BEGIN
          PSG_POKE(3,x-1);
       END;
       IF x > 1 THEN BEGIN
          PSG_POKE(5,x-2);
       END;
       FOR y := 0 to 255 DO BEGIN
           PSG_POKE(0,y);
           IF y > 0 THEN BEGIN
              PSG_POKE(2,y-1);
           END;
           IF y > 1 THEN BEGIN
              PSG_POKE(4,y-2);
           END;
       END;
   END;
   PSG_POKE(7,255);
END;

VAR
 x : INTEGER;
 y : INTEGER;
BEGIN
   POKE($FF7F,48);
   PSG1;
   PSG2;
   POKE($FF7F,51);
END.