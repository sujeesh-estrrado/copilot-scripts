IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GroupEmail_History]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[SP_GroupEmail_History]      
(   
@CurrentPage bigint=1,  
@PageSize bigint=10,    
@fromdate datetime = NULL,          
@Todate datetime = NULL,     
@flag bigint=0   
)        
as        
        
begin        
if(@flag=0)        
 begin        
        
  select EH.EmailHistoryId,EH.GroupEmail_Id,GE.GroupName,EH.Template_id,TG.Template_name,  
 --CONVERT(VARCHAR(10),EH.Created_date,103) Created_date ,  
  cast(CONVERT(varchar, EH.Created_date, 101) as datetime) Created_date,  
 EH.StatusName  from Tbl_EmailHistory EH left join   
 Tbl_GroupEmail GE on GE.GroupEmail_Id=EH.GroupEmail_Id left join  
 Tbl_Template_generation TG on TG.Template_id=EH.Template_id where   
-- CONVERT(VARCHAR(10),EH.Created_date,103)   
  EH.Created_date between @fromdate and @Todate  
 order by EmailHistoryId desc    
      
        
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);        
 end        
if(@flag=1)        
 begin        
  ---Pagination count get      
 select * into #temp from (        
    select EH.EmailHistoryId,EH.GroupEmail_Id,GE.GroupName,EH.Template_id,TG.Template_name,  
 --CONVERT(VARCHAR(10),EH.Created_date,103) Created_date ,  
  cast(CONVERT(varchar, EH.Created_date, 101) as datetime) Created_date,  
 EH.StatusName  from Tbl_EmailHistory EH left join   
 Tbl_GroupEmail GE on GE.GroupEmail_Id=EH.GroupEmail_Id left join  
 Tbl_Template_generation TG on TG.Template_id=EH.Template_id where   
 --CONVERT(VARCHAR(10),EH.Created_date,103)   
  EH.Created_date between @fromdate and @Todate  
  )base        
   select count(*) as totcount from #temp        
 end        
    
    
end     
    ');
END;
