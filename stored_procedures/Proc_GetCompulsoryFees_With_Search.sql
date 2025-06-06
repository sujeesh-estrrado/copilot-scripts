IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCompulsoryFees_With_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_GetCompulsoryFees_With_Search]                      
(@SearchTerm varchar(max))        
      
AS                      
BEGIN                   
SELECT ROW_NUMBER() OVER (ORDER BY CompulsoryFeeId DESC) AS num,Base.*  FROM       
      
(select c.*,d.Department_Name,c.TypeOfStudent typestu from dbo.Tbl_Fee_Compulsory c inner join     
Tbl_Department d on d.Department_Id=c.CourseId          
  )Base      
       
  WHERE               
 ( Department_Name like  ''''+ @SearchTerm+''%''    
 or TypeOfStudent like  ''''+ @SearchTerm+''%''    
 or  validity like  ''''+ @SearchTerm+''%'')                   
      
              
                
END
    ')
END;
