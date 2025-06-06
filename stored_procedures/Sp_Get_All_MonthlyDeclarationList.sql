IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_MonthlyDeclarationList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_All_MonthlyDeclarationList]    
AS    
declare @count bigint    
declare @Mapcount bigint    
declare @clubid bigint    
declare @tempbatch varchar(max)    
declare @finalbatch varchar(max)    
BEGIN    
create table #tab1(id bigint identity(1,1) primary key not null,Query varchar(MAX),Declaration_To varchar(50),MonthlyDeclaration_Id bigint,Depatment_Id bigint,    
Department_Name varchar(100),Warning varchar(max),Status bit,Batches varchar(max))    
insert into #tab1(Query,Declaration_To,MonthlyDeclaration_Id,Depatment_Id,Department_Name,Warning,Status,Batches)    
 select md.Query,md.Declaration_To,md.MonthlyDeclaration_Id,md.Department,    
 dp.Department_Name,md.Warning,md.Status,'''' from dbo.LMS_Tbl_Monthly_Declaration md   
   
 inner join dbo.Tbl_Course_Department cd on cd.Course_Department_Id=md.Department   
 inner join dbo.Tbl_Department dp on dp.Department_Id=cd.Department_Id where md.Del_Status=0    
  --select * from #tab1  
 create table #tab2(id bigint identity(1,1) primary key not null,Mapping_Id bigint,MonthlyDeclaration_Id bigint,Batches varchar(max))    
     
 set @count=(select max(id) from #tab1)    
 while @count>0    
 begin    
 truncate table #tab2    
 set @clubid=(select MonthlyDeclaration_Id from #tab1 where id=@count)    
 insert into #tab2(Mapping_Id,MonthlyDeclaration_Id,Batches)    
 select cm.Mapping_Id,cm.MonthlyDeclaration_Id,cbd.Batch_Code+''''+cs.Semester_Code as Batches from  dbo.LMS_Tbl_MonthDecl_BatchMapping cm    
 inner join Tbl_Course_Duration_Mapping cdm on cdm.Duration_Mapping_Id=cm.Batch_Id            
    INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id            
    INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id             
    INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id where cm.MonthlyDeclaration_Id=@clubid and cm.Status=0    
        
      set @Mapcount=(select max(id) from #tab2)    
      set @finalbatch=''''    
      while @Mapcount>0    
      begin    
        set @tempbatch=''''    
        set @tempbatch=(select Batches from #tab2 where id=@Mapcount)    
        if @finalbatch=''''    
        begin    
        print @tempbatch    
        set @finalbatch=@tempbatch    
        end    
        else    
        begin    
        set @finalbatch=@finalbatch+'', ''+@tempbatch    
        end    
      set @Mapcount=@Mapcount-1    
      end    
      update #tab1 set Batches=@finalbatch where id=@count    
 set @count=@count-1    
 end    
     
     
 select * from #tab1    
    
    
END
    ')
END
