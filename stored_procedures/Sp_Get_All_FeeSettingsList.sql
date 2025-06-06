IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_FeeSettingsList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Sp_Get_All_FeeSettingsList] --1,10,''as''          
(          
@CurrentPage int=null,          
@PageSize int=null,          
@SearchTerm varchar(100)          
)          
          
AS                        
                        
BEGIN                        
    SET NOCOUNT ON                        
                        
    DECLARE @SqlString nvarchar(max)                    
    Declare @SqlStringWithout nvarchar(max)                        
    Declare @UpperBand int                        
    Declare @LowerBand int                                
                            
    SET @LowerBand  = (@CurrentPage - 1) * @PageSize                        
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                            
                        
    BEGIN               
              
    IF @SearchTerm IS NOT NULL                  
                  
BEGIN      
    
 SET @SqlString=''WITH tempProfile AS          
 (SELECT ROW_NUMBER() OVER (ORDER BY Fee_Settings_Id DESC) AS num,Base.*  FROM     
 (SELECT f.*,c.Department_Name,fc.FeeCategory FeeCategoryName            
from Tbl_Fee_Settings F left join dbo.Tbl_Department c on f.Course_Id=c.Department_Id     
inner join Tbl_Feecategory Fc on fc.FeeCategoryId=f.Fee_Category           
 )Base    
     
  WHERE             
 ( Department_Name like  ''''''+ @SearchTerm+''%''''  
 OR FeeCategoryName like  ''''''+ @SearchTerm+''%''''  
 OR Fee_Code like  ''''''+ @SearchTerm+''%''''  
 OR Scheme  like  ''''''+ @SearchTerm+''%'''')      
 and FeeSetting_DeleteStatus=0      
 )    
     
 select     
     Fee_Settings_Id,     
     Department_Name,    
     FeeCategoryName,    
     Fee_Code,    
     Scheme,    
     num    
         
     FROM                         
            tempProfile where  num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)             
                  
                      
END          
    
IF (@SearchTerm is null or @SearchTerm = '''')                  
                  
begin    
SET @SqlString=''WITH tempProfile AS          
 (SELECT ROW_NUMBER() OVER (ORDER BY Fee_Settings_Id DESC) AS num,Base.*  FROM                   
    
    
(SELECT f.*,c.Department_Name,fc.FeeCategory FeeCategoryName            
from Tbl_Fee_Settings F left join dbo.Tbl_Department c on f.Course_Id=c.Department_Id     
inner join Tbl_Feecategory Fc on fc.FeeCategoryId=f.Fee_Category  )Base    
         
 where ( FeeSetting_DeleteStatus=0  )    
 )    
         
         
      select     
     Fee_Settings_Id,     
     Department_Name,    
     FeeCategoryName,    
     Fee_Code,    
     Scheme,    
     num    
         
     FROM                         
            tempProfile where  num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)             
            
        end    
         EXEC sp_executesql @SqlString                        
                    
                        
    END     
    end
    ')
END
