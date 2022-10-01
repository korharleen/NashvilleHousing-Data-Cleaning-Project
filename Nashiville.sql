/*
Cleaning Data in SQL Queries
*/


Select *
From NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format --already in the exact same format that I wanted


Select saleDate
From NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field



Select 
distinct soldasvacant,
count(soldasvacant)
from NashvilleHousing
group by 1

Select 
CASE WHEN soldasvacant='Y' THEN 'Yes'
     WHEN soldasvacant ='N'THEN 'No'
     ELSE soldasvacant
     END
from NashvilleHousing

update nashvilleHousing
Set soldasvacant = (Select 
CASE WHEN soldasvacant='Y' THEN 'Yes'
     WHEN soldasvacant ='N'THEN 'No'
     ELSE soldasvacant
     END)


--------------------------------------------------------------------------------------------------------------------------

----- Remove Duplicates-----
------using a WINDOW FUNCTION


delete from NashvilleHousing
where uniqueID IN(
select UniqueId from
(Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) as row_num
From NashvilleHousing) rn
where rn.row_num>1)


Select * from NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data

Select *
From NashvilleHousing
Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
coalesce(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID 
Where a.PropertyAddress is null


Update NashvilleHousing
SET PropertyAddress = Coalesce(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID 
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 ) as Address,

SUBSTRING(PropertyAddress, CHARINDEX(",", PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

