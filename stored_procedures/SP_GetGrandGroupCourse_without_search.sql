IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetGrandGroupCourse_without_search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetGrandGroupCourse_without_search] --''COURSES NO MORE OFFERING-DIPLOMA IN MARKETING''                 
AS                  
BEGIN           
        
SELECT  GrandGroupCodeId,GrandGroupCode,GrandGroupDesc,               
ROW_NUMBER() OVER (partition by GrandGroupCodeId  order by GrandGroupCodeId)as num      
   from Tbl_Grand_Group where  delstatus=0    
          
END
');
END;