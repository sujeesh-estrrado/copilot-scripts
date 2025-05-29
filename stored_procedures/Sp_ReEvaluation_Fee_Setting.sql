IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_ReEvaluation_Fee_Setting]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_ReEvaluation_Fee_Setting]      
(        
@Flag bigint=0,         
@Faclty_Id bigint=0,    
@Programme_Id  bigint =0,           
@Intake_Id   bigint =0,          
@Semester_Id bigint =0  ,    
@ReEvaluation_Fee_Master_Id bigint=0,    
@Fee_Settings_Id bigint=0,    
@Created_By bigint=0,    
@Course_Id   bigint=0,      
@Fee_Amount   decimal(8,2)=0    
)        
as        
begin        
 if(@Flag = 1)--Insert    Master    
  begin        
   if not exists(select * from Tbl_ReEvaluation_Fee_Master where Faclty_Id=@Faclty_Id and Programme_Id=@Programme_Id and Intake_Id=@Intake_Id and Semester_Id=@Semester_Id and delete_Status=0)     
 begin  
 INSERT INTO Tbl_ReEvaluation_Fee_Master        
    (   
    Faclty_Id  ,  
 Programme_Id   
    ,Intake_Id        
    ,Semester_Id      
    ,Created_Date        
    ,delete_Status)        
   VALUES        
    (@Faclty_Id,    
    @Programme_Id,    
     @Intake_Id,       
     @Semester_Id,GETDATE(),0)      
     select SCOPE_IDENTITY();    
  end  
  end        
  if(@Flag = 2)--Insert    settings    
  begin        
   if not exists(select * from Tbl_ReEvaluation_Fee_Settings where ReEvaluation_Fee_Master_Id=@ReEvaluation_Fee_Master_Id and Course_Id=@Course_Id and delete_Status=0)     
 begin      
   INSERT INTO Tbl_ReEvaluation_Fee_Settings        
    (ReEvaluation_Fee_Master_Id        
    ,Course_Id        
    ,Fee_Amount      
    ,Created_By        
    ,Created_date,    
    Delete_Status)        
   VALUES        
    (@ReEvaluation_Fee_Master_Id        
    ,@Course_Id        
    ,@Fee_Amount      
    ,@Created_By,GETDATE(),0)        
  end  
  end    
  if(@Flag = 3)--select list  
  begin        
   select distinct FM.ReEvaluation_Fee_Master_Id,concat(D.Department_Name,''-'',D.Course_Code)as programmename,BD.Batch_Id,BD.Batch_Code,CS.Semester_Name, count(Course_Id) as coursecount  
     
   from Tbl_ReEvaluation_Fee_Master FM  
   inner join Tbl_ReEvaluation_Fee_Settings FS on FS.ReEvaluation_Fee_Master_Id=FM.ReEvaluation_Fee_Master_Id  
   left join Tbl_Department D on D.Department_Id=FM.Programme_Id  
   left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=FM.Intake_Id  
   left join Tbl_Course_Semester CS on cs.Semester_Id=FM.Semester_Id  
   where   
   (FM.Programme_Id=@Programme_Id or @Programme_Id=0)  
   and (FM.Intake_Id=@Intake_Id or @Intake_Id=0)  
   and (FM.Semester_Id=@Semester_Id or @Semester_Id=0) and  
    FM.delete_Status=0     
   group by D.Department_Name,D.Course_Code,BD.Batch_Code,BD.Batch_Id,CS.Semester_Name,FM.ReEvaluation_Fee_Master_Id  
   end  
   if(@Flag = 4)--delete  
   Begin  
  Update  Tbl_ReEvaluation_Fee_Master set delete_Status=1 where ReEvaluation_Fee_Master_Id=@ReEvaluation_Fee_Master_Id  
   Update  Tbl_ReEvaluation_Fee_Settings set delete_Status=1 where ReEvaluation_Fee_Master_Id=@ReEvaluation_Fee_Master_Id  
  end    
   if(@Flag = 5)--delete  
   Begin  
  select * from   Tbl_ReEvaluation_Fee_Master  where ReEvaluation_Fee_Master_Id=@ReEvaluation_Fee_Master_Id and  delete_Status=0  
   
  end   
  if(@Flag = 6)--Update  
  begin        
      
   Update Tbl_ReEvaluation_Fee_Settings        
    set    
     Fee_Amount  =@Fee_Amount  ,Updated_Date=getdate()  
           
     where ReEvaluation_Fee_Master_Id=@ReEvaluation_Fee_Master_Id   and Course_Id=@Course_Id and Delete_Status=0   
  
  end    
end   ');
END;