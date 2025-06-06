IF EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Candidate_Document]')
    AND type = N'P'
)
BEGIN
    EXEC('
  
ALTER procedure [dbo].[Sp_Candidate_Document] --,0,0,0,'''',0,'''','''',1,0,0,''LOCAL''        
@Flag bigint =0,        
@Id   bigint =0,         
@Candidate_Id bigint=0,        
@Certificate_Id bigint=0,        
@Document_URL varchar(MAX)='''',        
@Verify varchar(50)='''',        
@Create_Date datetime='''',        
@Updated_Date datetime='''',        
@PgmCode1 varchar(MAX)='''',        
@PgmCode2 varchar(MAX)='''',        
@PgmCode3 varchar(MAX)='''',        
@SType varchar(MAX)='''',        
@RejectionRemark varchar(MAX)='''',        
@Src varchar(50) =''Setting'',        
@Verified_by bigint=0,
@DocumentName varchar(200)=''''
AS        
BEGIN        
 if(@Flag=1)--Get uploaded documents of a candidate         
 begin        
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,        
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,        
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark,marketingverifydate,AdmissionVerifydate        
          
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN        
                        dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id        
  WHERE        (SDU.DeleteStatus = N''false'')  and (SDU.StudentId= @Candidate_Id) and ((CM.id = @Certificate_Id  ) or @Certificate_Id =0)  --AND SDU.IsInternal=0       
 end        
 if(@Flag=2)--Add new document        
 begin        
  begin        
   INSERT INTO [dbo].[Tbl_Candidate_Document]([Candidate_Id],[Certificate_Id],[Delete_Status])        
   VALUES      (@Candidate_Id,@Certificate_Id,0)        
  end        
 end        
 if(@Flag=3)--Marketing Verify Document        
 begin        
  update [tbl_StudentDocUpload] set MarketingVerify=''True'',MarketingVerifyBy = @Verified_by, LastUpdated = Getdate(),marketingverifydate=getdate() where [id]= @id        
         
 end        
 --if(@Flag=4)--Update Document        
 --begin        
 -- UPDATE [dbo].[Tbl_Candidate_Document]        
 -- SET  [Document_URL] = @Document_URL        
           
 --  ,[Verify] = ''False''        
 -- WHERE Id = @Id        
 --end        
 if(@Flag=5)--Delete Document        
 begin        
  UPDATE [dbo].[Tbl_Candidate_Document]        
  SET  Delete_Status = 1        
  WHERE Id = @Id        
 end        
 if(@Flag=6)--Get Needed Doument list        
 begin        
  SELECT        DISTINCT CM.Certificate_id as Certificate_id, DOC.Document_Name as Document_Name        
  FROM            dbo.tbl_certificate_maping AS CM INNER JOIN        
         dbo.tbl_certificate_master AS DOC ON CM.Certificate_id = DOC.id        
  WHERE        (CM.program_code = @PgmCode1 or CM.program_code = @PgmCode2 or CM.program_code = @PgmCode3 ) AND (CM.status = ''true'') AND (DOC.Type_of_student = @SType)        
 end        
-- if(@Flag=7)--Get Document Details by id        
-- begin        
--  select Document_URL,Verify from Tbl_Candidate_Document D        
--inner join tbl_certificate_master M on M.id=D.Certificate_Id        
--  WHERE Candidate_Id=@Candidate_Id and Certificate_Id=@Certificate_Id and  D.Delete_Status = N''false''        
-- end        
  if(@Flag=8)--Get Document Details with verified emplyee name        
 begin        
SELECT        CD.Id, CD.Candidate_Id, CD.Certificate_Id, CM.Document_Name
--, CD.Document_URL, CD.Verify, CD.Create_Date, CD.Updated_Date,         
                       ---  ,dbo.Tbl_Employee.Employee_FName + '' '' + dbo.Tbl_Employee.Employee_LName AS verified_by        
FROM            dbo.tbl_certificate_master AS CM INNER JOIN        
                         dbo.Tbl_Candidate_Document AS CD ON CM.id = CD.Certificate_Id 
                        -- left JOIN        dbo.Tbl_Employee ON CD.Verified_by = dbo.Tbl_Employee.Employee_Id        
  WHERE Candidate_Id=@Candidate_Id  and  CD.Delete_Status = N''false''        
 end        
 if(@Flag=9) -- Marketing Reject Candidate Doc        
 begin        
 update [tbl_StudentDocUpload]         
 set MarketingVerify=''False'',MarketingVerifyBy = @Verified_by, LastUpdated = Getdate() ,MarketingRejectionRemark =@RejectionRemark,marketingverifydate=getdate()        
 where [id]= @id        
 end        
 --UPDATE [dbo].[Tbl_Candidate_Document]        
 -- SET  [Verify] = ''False''        
 --  ,[Updated_Date] = Getdate()        
 --  ,Verified_by = @Verified_by        
 -- WHERE Id = @Id        
         
        
  if(@Flag=10)--Add new document        
 begin        
 if not exists(select * from Tbl_Candidate_Document where Candidate_Id=@Candidate_Id and Certificate_Id=@Certificate_Id and Delete_Status = 0)        
 begin        
        
  INSERT INTO [dbo].Tbl_Candidate_Document([Candidate_Id],[Certificate_Id],        
     [Delete_Status],Src)        
  VALUES      (@Candidate_Id,@Certificate_Id,0,@Src)        
  end        
 end        
 if(@Flag=11)--View Candidate Document        
 begin    
 DECLARE @TypeOfStudent VARCHAR(20);
 SELECT @TypeOfStudent = TypeOfStudent  
    FROM Tbl_Candidate_Personal_Det  
    WHERE Candidate_Id = @Candidate_Id;  
  SELECT   distinct     CD.Id, CD.Candidate_Id, CD.Certificate_Id, CD.Delete_Status, CM.Document_Name, CM.Type_of_student, CM.StaticDoc,CM.Category_id  ,CC.category as CategoryName ,
  CASE 
            WHEN MAX(CAST(sd.IsInternal AS INT)) = 1 THEN ''Internal'' 
            ELSE ''Public'' 
        END AS DocumentType    

FROM            dbo.Tbl_Candidate_Document AS CD left JOIN        
                         dbo.tbl_certificate_master AS CM ON CD.Certificate_Id = CM.id 
LEFT JOIN tbl_StudentDocUpload sd ON sd.StudentId = CD.Candidate_Id AND sd.DocType = CD.Certificate_Id
       left join tbl_certificate_category cc on cc.id=CM.Category_id     
     where CD.Candidate_Id = @Candidate_Id and CD.Delete_Status =0 and CM.delete_status=0
       GROUP BY 
    CD.Id, 
    CD.Candidate_Id, 
    CD.Certificate_Id, 
    CD.Delete_Status, 
    CM.Document_Name, 
    CM.Type_of_student, 
    CM.StaticDoc, 
    CM.Category_id, 
    CC.category


--  SELECT        CD.Id, CD.Candidate_Id, CD.Certificate_Id, CD.Delete_Status, CM.Document_Name, CM.Type_of_student, CM.StaticDoc,CM.Category_id  ,CC.category as CategoryName, CASE 
--            WHEN sd.IsInternal = 1 THEN ''Internal'' 
--            ELSE ''Public'' 
--        END AS DocumentType    
--FROM            dbo.Tbl_Candidate_Document AS CD INNER JOIN        
--                         dbo.tbl_certificate_master AS CM ON CD.Certificate_Id = CM.id
--                       left join tbl_StudentDocUpload sd on sd.DocType= CD.Certificate_Id
                         
--       left join tbl_certificate_category cc on cc.id=CM.Category_id     
--     where CD.Candidate_Id = @Candidate_Id and CD.Delete_Status =0 and CM.delete_status=0 AND CM.Type_of_student = @TypeOfStudent  order by CM.Category_id    
  --30223         
 end        
 if(@Flag=12)--Remove document mapping        
 begin        
  if exists(select * from Tbl_Candidate_Document where Candidate_Id=@Candidate_Id and Certificate_Id=@Certificate_Id and Delete_Status = 0)        
  begin        
   if not exists(SELECT * FROM tbl_StudentDocUpload where (MarketingVerify = N''true'' or MarketingVerify is null ) and DeleteStatus = N''false''        
        and DocType = @Certificate_Id and StudentId= @Candidate_Id)        
   begin        
    update Tbl_Candidate_Document set Delete_Status=1 where Candidate_Id=@Candidate_Id and Certificate_Id=@Certificate_Id and (Src !=''Req'' or Src is null)        
    --and @Certificate_Id not in  (SELECT DocType FROM tbl_StudentDocUpload where (MarketingVerify = N''true'' or MarketingVerify is null ) and DeleteStatus = N''false'' and StudentId= @Candidate_Id)        
   end        
  end        
 end        
 if(@Flag=13)--Admission Verify Document        
 begin        
  update [tbl_StudentDocUpload] set AdmissionVerify=''True'',AdmissionVerifyBy = @Verified_by, LastUpdated = Getdate(),AdmissionVerifydate=getdate() where [id]= @id        
         
 end        
  if(@Flag=14) -- Admission Reject Candidate Doc        
 begin        
 update [tbl_StudentDocUpload]         
 set AdmissionVerify=''False'',AdmissionVerifyBy = @Verified_by, LastUpdated = Getdate() ,AdmissionRejectionRemark =@RejectionRemark,AdmissionVerifydate=getdate()        
 where [id]= @id        
 end        
 if(@Flag=15)--Get marketing verified documents of a candidate and by Certificate_Id        
 begin        
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,        
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,        
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark        
          
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN        
                        dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id        
  WHERE        (SDU.MarketingVerify = N''true'') and (SDU.DeleteStatus = N''false'') and (SDU.StudentId= @Candidate_Id) and (CM.id = @Certificate_Id or @Certificate_Id =0)        
 end        
        
 if(@Flag=16)--Get marketing documents of a candidate and by Certificate_Id -- Non rejected        
 begin        
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,        
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,CM.Category_id,        
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark        
          
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN        
  dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id        
  WHERE        (SDU.MarketingVerify != N''false'' or SDU.MarketingVerify is null)and SDU.isinternal=0 and (SDU.DeleteStatus = N''false'') and (SDU.StudentId= @Candidate_Id) and (CM.id = @Certificate_Id or @Certificate_Id =0)        
 end        
 if(@Flag=17)--Get NonStaic Documents        
 begin        
  select * from tbl_certificate_master where StaticDoc != 1 or StaticDoc is null        
 end        
 if(@Flag=18)--Get Staic Documents        
 begin        
  select * from tbl_certificate_master where StaticDoc = 1        
 end        
 if(@Flag=19)--Get marketing documents of a candidate and by Certificate_Id -- verified by marketing        
 begin        
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,        
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,        
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark        
          
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN        
                        dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id        
  WHERE        (SDU.MarketingVerify != 0 ) and (SDU.DeleteStatus = 0) and (SDU.StudentId= @Candidate_Id) and (CM.id = @Certificate_Id or @Certificate_Id =0)     
 end        
 if(@Flag=20)--Get marketing documents of a candidate and by Certificate_Id -- verified byadmission        
 begin        
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,        
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,        
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark        
          
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN        
                        dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id        
  WHERE        (SDU.AdmissionVerify != 0 ) and (SDU.DeleteStatus = 0) and (SDU.StudentId= @Candidate_Id) and (CM.id = @Certificate_Id or @Certificate_Id =0)      
 end        
  if(@Flag=21)--Get marketing documents of a candidate and by Certificate_Id -- verified byadmission        
 begin        
  select * from tbl_certificate_master M        
  left join tbl_StudentDocUpload U on U.DocType=M.id where U.id=@Id and Delete_Status=0       
          
  end        
 if(@Flag=22)        
 begin        
  INSERT INTO [dbo].[Tbl_DocSkipLog]        
           ([DocID]        
           ,[StudID]        
           ,[EmpID]        
     ,Remark        
           ,EType        
           ,[UpdatedDate]        
           ,[Status])        
     VALUES        
           (@Certificate_Id        
           ,@Candidate_Id        
           ,@Verified_by        
     ,@RejectionRemark        
           ,@SType       
           ,getdate()        
           ,1)        
 end        
 if(@Flag=23)        
 begin        
  select * from Tbl_DocSkipLog        
  where         
   StudID = @Candidate_Id        
   and Status =1        
   and (EType = @SType or @SType=''0'')        
   and (DocID = @Certificate_Id or @Certificate_Id=0)        
 end        
        
  if(@Flag=24)      
 begin      
      
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,      
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,      
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark      
        
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN      
                        dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN      
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN      
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id      
  WHERE        (SDU.MarketingVerify != 0 ) and (SDU.DeleteStatus = 0) and  (CM.Category_id = @id ) and  (SDU.StudentId= @Candidate_Id)    
  and (StaticDoc!=1 or StaticDoc is null)  
 end      
        
     if(@Flag=25)      
 begin      
      
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,      
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,      
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark      
        
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN      
                        dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN      
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN      
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id      
  WHERE        (SDU.AdmissionVerify != 0 ) and (SDU.DeleteStatus = 0) and  (CM.Category_id = @id ) and  (SDU.StudentId= @Candidate_Id) and   
  (StaticDoc!=1 or StaticDoc is null) 
 end      
 if(@Flag=26)      
 begin      
      
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,      
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,      
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark      
        
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN      
                        dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN      
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN      
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id      
  WHERE        (SDU.DeleteStatus = 0) and  (CM.Category_id = @id ) and  (SDU.StudentId= @Candidate_Id)    and (StaticDoc!=1 or StaticDoc is null)   
 end     
 

  if(@Flag=27) -- GetUploadedDocMandatory    
 begin        
  SELECT        CD.Id, CD.Candidate_Id, CD.Certificate_Id, CD.Delete_Status, CM.Document_Name, CM.Type_of_student, CM.StaticDoc,CM.Category_id  ,CC.category as CategoryName      
FROM            dbo.Tbl_Candidate_Document AS CD INNER JOIN        
                         dbo.tbl_certificate_master AS CM ON CD.Certificate_Id = CM.id     
       left join tbl_certificate_category cc on cc.id=CM.Category_id     
       left join tbl_certificate_maping cem on cem.Certificate_id = cm.id
     where CD.Candidate_Id = @Candidate_Id and CD.Delete_Status =0 and cem.IsMandatory=1 order by CM.Category_id     
  --30223         
 end
  if(@Flag=28)--download documents of a candidate         
 begin        
  SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,        
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,        
    SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark,marketingverifydate,AdmissionVerifydate        
          
  FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN        
                        dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN        
                        dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id        
  WHERE        (SDU.DeleteStatus = N''false'') and (SDU.StudentId= @Candidate_Id) and (SDU.DocumentName = @DocumentName )     
 end    
 
 if(@Flag=100)--View Candidate Document        
 begin        



  --SELECT        SDU.id,CM.Document_Name as CertificateTitle,SDU.StudentId, SDU.DocumentName, SDU.DocumentLoc,SDU.MarketingVerify,        
  --  CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by,   SDU.AdmissionVerify, CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by,        
  --  SDU.CreatedDateDate, SDU.LastUpdated, SDU.DeleteStatus, CM.id AS CertificateID,MarketingRejectionRemark,AdmissionRejectionRemark,marketingverifydate,AdmissionVerifydate ,   
  --        CM.ID AS Certificate_Id, CM.Document_Name AS Document_Name,CC.category as CategoryName
  --FROM    dbo.tbl_StudentDocUpload AS SDU INNER JOIN        
  --                      dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id LEFT OUTER JOIN        
  --                      dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id LEFT OUTER JOIN        
  --                      dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id   
        --               left join tbl_certificate_category cc on cc.id=CM.Category_id  
  --WHERE        (SDU.DeleteStatus = N''false'')  and (SDU.StudentId= @Candidate_Id
  --) and ((CM.id = @Certificate_Id) or @Certificate_Id =0)  AND SDU.IsInternal=0
         

          SELECT 
    SDU.id, 
    CM.Document_Name as CertificateTitle, 
    SDU.StudentId, 
    SDU.DocumentName, 
    SDU.DocumentLoc, 
    SDU.MarketingVerify, 
    CONCAT(MarkEmp.Employee_FName, '' '', MarkEmp.Employee_LName) AS MarketingVerified_by, 
    SDU.AdmissionVerify, 
    CONCAT(AdmisEmp.Employee_FName, '' '', AdmisEmp.Employee_LName) AS AdmissionVerified_by, 
    SDU.CreatedDateDate, 
    SDU.LastUpdated, 
    SDU.DeleteStatus, 
    CM.id AS CertificateID, 
    MarketingRejectionRemark, 
    AdmissionRejectionRemark, 
    marketingverifydate, 
    AdmissionVerifydate, 
    CM.ID AS Certificate_Id, 
    CM.Document_Name AS Document_Name, 
    CC.category as CategoryName  -- Ensure this is correctly retrieved
FROM 
    dbo.tbl_StudentDocUpload AS SDU 
    INNER JOIN dbo.tbl_certificate_master AS CM ON SDU.DocType = CM.id 
    LEFT OUTER JOIN dbo.Tbl_Employee AS MarkEmp ON SDU.MarketingVerifyBy = MarkEmp.Employee_Id 
    LEFT OUTER JOIN dbo.Tbl_Employee AS AdmisEmp ON SDU.AdmissionVerifyBy = AdmisEmp.Employee_Id 
    LEFT JOIN tbl_certificate_category cc ON cc.id = CM.Category_id 
WHERE 
    SDU.DeleteStatus = N''false'' 
    AND SDU.StudentId = @Candidate_Id 
    AND (CM.id = @Certificate_Id OR @Certificate_Id = 0) 
    AND SDU.IsInternal = 0; 


 end     
END
    ')
END
