create or alter procedure WithOutParameters
    @RandResult int output
    ,@RandResult2 int output
    ,@TextResult varchar(200) output
as
begin
    declare @t1 table (id int, fname varchar(100))
    declare @t2 table (id int, fname varchar(100),lname varchar(100))
    insert into @t1 (id,fname) values (1,'Ala'),(2,'Beata')
    insert into @t2 (id,fname,lname) values (1,'Roman','Git'),(2,'Kajetan','Tfs')
    select * from @t1;
    select * from @t2;
    select @RandResult = 10 * rand();
    select @RandResult2 = 10 * rand();
    select @TextResult='Jadą dzieci jadą koło mego sadu';
    return 10 * rand();
end;
