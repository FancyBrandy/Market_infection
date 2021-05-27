with ada.Text_IO,ada.Numerics.Discrete_Random;
WITH Ada.Calendar;
use ada.Calendar;
use ada.Text_IO;
procedure Main is


   type arr is array(1..10,1..10) of Boolean;
   protected Market is
      procedure set(x:Integer;y:Integer);
      function get(x:Integer;y:Integer) return Boolean;
      procedure inc;
      function num_people_infected return Integer;
   private
      Markt: arr :=((false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false),
                    (false,false,false,false,false,false,false,false,false,false));

      people_cal:Integer:=5;
   end Market;


   type PString is access String;
   type PBoolean is access Boolean;


    protected generate is
      function rand_move return Integer;
   end generate;


   protected Printing is-- the printing should be done by protected object
		entry Print( s: string );
	end Printing;


   task type Customer(name: PString; is_infected: PBoolean);


   --------------------body---------------------
   protected body Market is
      procedure set(x:Integer;y:Integer) is
      begin
         Markt(x,y):=true;
      end set;
      function get(x:Integer;y:Integer)  return Boolean is
      begin
         return Markt(x,y);
      end get;

      procedure inc is
      begin
         people_cal:=people_cal+1;
      end inc;
      function num_people_infected return Integer is
      begin
         return people_cal;
      end num_people_infected;



   end Market;

   protected body generate is
      function rand_move return Integer is
         type data is range 1..10;
         package Gen_Pack is new ada.numerics.discrete_random(data);
         use Gen_Pack;
         g: Gen_Pack.Generator;
      begin
         Reset(g);
         return Integer(Random(g));
      end rand_move;
   end generate;


   protected body Printing is
		entry Print ( s: string ) when true is
                begin Put_Line(s);
                end Print;
   end Printing;

   task body Customer is
      Px:Integer;
      Py:Integer;
      moving:Integer;
      inTime:Float:=0.0;
   begin
      Px:=generate.rand_move;
      Py:=generate.rand_move;
      while inTime<2.0 loop
         moving:=generate.rand_move;
         if (moving=1 or moving=2) then
            Px:=Px+1;
            if Px>10 then
               Px:=Px-2;
            end if;
         elsif (moving=3 or moving=4) then
            Py:=Py+1;
            if Py>10 then
               Py:=Py-2;
            end if;
         elsif (moving=5 or moving=6) then
            Px:=Px-1;
            if Px<1 then
               Px:=Px+2;
            end if;
         elsif (moving=7 or moving=8) then
            Py:=Py-1;
            if Py<1 then
               Py:=Py+2;
            end if;
         else
            Px:=Px+1;
            if Px>10 then
               Px:=Px-2;
            end if;
            Py:=Py-1;
            if Py<1 then
               Py:=Py+2;
            end if;
         end if;
         if is_infected.all=true then
            if Market.get(px,py)=false then
               Printing.Print("the area "& Integer'Image(Px)&", "& Integer'Image(Px)&" is infected by customer"& name.all);
            end if;
            Market.set(Px,Py);
         else
            if Market.get(px,py)=true then
               Printing.Print("the area "& Integer'Image(Px)&", "& Integer'Image(Px)&" INFECTS customer"& name.all);
               is_infected.all:=true;
               Market.inc;
            end if;
         end if;
         inTime:=inTime+0.5;
         delay 0.5;
      end loop;
      Printing.Print("Customer "&name.all&" leaves the markt now!");
   end Customer;

   timer:Float:=0.0;
   counter:Integer:=0;
   type PC is access Customer;
   CustomerGroup: array(1..150) of PC;
   area_infect:Integer:=0;
   people_infect:Integer:=0;
begin


   for i in 1..5 loop
      counter:=counter+1;
      CustomerGroup(i):=new Customer(new String'(Integer'Image(counter)), new Boolean'(true));
   end loop;

   counter:=0;
   delay 2.0;
   -- the first 5 customer we create seperately, and we calculate the time seperately as well
   timer:=timer+2.0;

   while timer<60.0 loop
      counter:=counter+1;
      for i in 1..5 loop
         CustomerGroup(i):=new Customer(new String'(Integer'Image(i+counter*5)), new Boolean'(false));
      end loop;
      delay 2.0;---- every customer stays in the market for 2 mins;
      timer:=timer+2.0;

   end loop;

   delay 5.0;----we do the final calculation after some time just to be safe

   for i in 1..10 loop
      for j in 1..10 loop
         if Market.get(i,j)=true then
            area_infect:=area_infect+1;
         end if;
      end loop;
   end loop;



   Put_Line(Integer'Image(area_infect)& " area in the market gets infected out of 100");
   Put_Line(Integer'Image(Market.num_people_infected)& " people in the market gets infected out of 150");



end main;









