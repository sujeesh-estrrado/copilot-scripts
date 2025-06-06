IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[data]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[data] --0,11,''''          
(                           
@CurrentPage int=null ,                   
@PageSize int=null   ,                
@SearchTerm varchar(100)                      
)                        
                            
AS            
                                                               
BEGIN                        
    SET NOCOUNT ON                        
                        
    DECLARE @SqlString nvarchar(max)                    
    --Declare @SqlStringWithout nvarchar(max)                        
    Declare @UpperBand int                        
    Declare @LowerBand int                                
                            
    SET @LowerBand  = (@CurrentPage - 1) * @PageSize                        
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                            
                        
    --BEGIN                    
    IF @SearchTerm IS NOT NULL                  
                  
BEGIN                  
                  
 SET @SqlString='' WITH tempProfile AS (SELECT ROW_NUMBER() OVER (ORDER BY GroupCourseCodeId desc) as num,Base.*  FROM              
    (SELECT DISTINCT          
    GroupCourseCodeId,        
    GroupCourseCode,        
    GroupCourseName,        
    Qualification      
  
from Tbl_Group_Course)Base          
        
 WHERE           
 GroupCourseCode like   ''''''+ @SearchTerm +''%''''   
or  GroupCourseName like  ''''''+ @SearchTerm +''%''''              
  )          
    
  select         
  GroupCourseCodeId,        
  GroupCourseCode,        
  GroupCourseName,        
  Qualification,      
  num       
         
  from tempProfile where num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)             
          
  END        
                    
 IF (@SearchTerm is null or @SearchTerm = '''')                  
                  
 begin         
        
SET @SqlString=''WITH tempProfile AS  (SELECT ROW_NUMBER() OVER (ORDER BY GroupCourseCodeId desc) as num,Base.*  FROM              
    (SELECT DISTINCT          
    GroupCourseCodeId,        
    GroupCourseCode,        
    GroupCourseName,        
    Qualification      
      
 from Tbl_Group_Course) Base    
 )  
  select         
  GroupCourseCodeId,        
  GroupCourseCode,        
  GroupCourseName,        
  Qualification,      
  num       
          
  from tempProfile  where  num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)             
          
    end      
       
     EXEC sp_executesql @SqlString                        
  end

    ')
END
