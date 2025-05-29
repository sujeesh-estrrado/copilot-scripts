IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SearchAll_GroupNameEmail]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_SearchAll_GroupNameEmail]                  
(       
@CurrentPage int=1,                  
@pagesize bigint =10,                  
@Type nvarchar(50)='''',                   
@Status bigint=0,                  
@Department_Id bigint=0,      
@Intake_Id bigint=0 ,      
@Country bigint=0,      
@Gender varchar(50)='''',      
@Age bigint=0,      
@Flag bigint=0    
)       
AS      
BEGIN      
if(@Flag=0)                  
begin         
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE order by GroupEmail_Id desc     
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);        
      
End      
if(@Flag=1)                  
begin         
--search type only        
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)            
begin      
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE   where Type=@Type order by GroupEmail_Id desc      
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
--search Status only      
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin      
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Status=@Status order by GroupEmail_Id desc     
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
--search Department_Id only      
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin     
    
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Department_Id=@Department_Id order by GroupEmail_Id desc     
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
      
--search Intake_Id only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin     
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Intake_Id=@Intake_Id order by GroupEmail_Id desc      
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
--search Country only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin     
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Candidate_Nationality=@Country order by GroupEmail_Id desc     
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
--search Gender only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin     
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Candidate_Gender=@Gender order by GroupEmail_Id desc     
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);        
End      
--search Age only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin     
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Candidate_Dob=@Age order by GroupEmail_Id desc     
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);        
End      
End      
      
if(@flag=2)        
 begin       
      
 --Display all      
--search type only        
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)            
begin      
      
   select * into #temp from (       
   Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE   where Type=@Type       
      
    )base        
   select count(*) as totcount from #temp       
      
End      
      
      
 --search Status only      
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)      
begin      
   select * into #temp1 from (       
 Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Status=@Status    
      
    )base        
   select count(*) as totcount from #temp1       
      
End      
--search Department_Id only      
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)      
begin      
      
   select * into #temp2 from (       
   Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Department_Id=@Department_Id     
      
    )base        
   select count(*) as totcount from #temp2       
End      
--search Intake_Id only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)      
begin    
      
   select * into #temp3 from (       
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Intake_Id=@Intake_Id     
      
    )base        
   select count(*) as totcount from #temp3      
End      
  --search Country only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)      
begin    
      
   select * into #temp4 from (       
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Candidate_Nationality=@Country     
      
    )base        
   select count(*) as totcount from #temp4    
End      
  --search Gender only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)      
begin    
      
   select * into #temp5 from (       
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Candidate_Gender=@Gender    
      
    )base        
   select count(*) as totcount from #temp5    
End      
    --search Age only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)      
begin    
      
   select * into #temp6 from (       
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE where Candidate_Dob=@Age     
      
    )base        
   select count(*) as totcount from #temp6    
End      
       
 End      
  if(@Flag=3)                  
begin         
 select * into #temp7 from (    
Select GroupEmail_Id,GroupName ,CONVERT(VARCHAR(10),Created_date,103) Created_date    
 from Tbl_GroupEmail As GE     
     )base        
   select count(*) as totcount from #temp7        
      
End      
      
END
');
END;