package stosPackage is 
 	type stos is array(integer range<>)of Float; 
	type stosStruktura(pojemnosc:Integer)is 
		record
			st:stos(1..pojemnosc);
			wsk:Integer:=0;
	    end record;
	 procedure wstaw(s: Access stosStruktura; x:in Float);
	 procedure pobierz(s: Access stosStruktura; x:out Float);
	 function pelny (s:Access stosStruktura) return boolean; 
	 function Pusty (s:Access stosStruktura) return boolean;
 end stosPackage; 
