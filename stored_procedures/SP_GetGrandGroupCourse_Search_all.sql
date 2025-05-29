IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetGrandGroupCourse_Search_all]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetGrandGroupCourse_Search_all] --''''C120''''      
(                  
@SearchTerm  varchar(100)                  
)                
         
AS                
BEGIN 

SELECT * from (SELECT                   
ROW_NUMBER() OVER                                     
   (PARTITION BY  GrandGroupCodeId  order by GrandGroupCodeId)as num,GrandGroupCodeId,GrandGroupCode,GrandGroupDesc    

  from Tbl_Grand_Group ) Base      
    
 WHERE       
 ( GrandGroupCode like  ''''+ @SearchTerm+''%'' )      
 END
    ');
END;
