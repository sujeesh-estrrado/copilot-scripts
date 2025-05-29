IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_select_mapping_IDS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_select_mapping_IDS]
AS
BEGIN

select DISTINCT
	  IM.InterestLevel_ID,
	  IM.Interest_level_Name,
	STRING_AGG(LSM.Lead_Status_Name, '', '') AS Lead_Status_Names
	from Tbl_Interest_level_Master IM
	INNER join Tbl_Interest_level_Mapping ILM on ILM.InterestLevel_ID = IM.InterestLevel_ID
	INNER join Tbl_Lead_Status_Master LSM on LSM.Lead_Status_Id = ILM.Lead_Status_Id 
	where IM.Interest_level_DelStatus = 0
	GROUP by IM.InterestLevel_ID,IM.Interest_level_Name,LSM.Lead_Status_Name


	END


');
END;
