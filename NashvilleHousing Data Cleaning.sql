SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing

-- Standarize Date Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject2.dbo.NashvilleHousing

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
ADD SaleDateConverted Date;

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN SaleDate;

-- Populate Property Address data

SELECT PropertyAddress
FROM PortfolioProject2.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL;

SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--Breaking out Address into Individual Columns (Address, City, State)

SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing;

SELECT
SUBSTRING(PropertyAddress, 0, CHARINDEX(',', PropertyAddress) -1) as Addres,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
FROM PortfolioProject2.dbo.NashvilleHousing

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 0, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

--Breaking out Owner Address into individual Colums using PARSENAME

SELECT OwnerAddress
FROM PortfolioProject2.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
FROM PortfolioProject2.dbo.NashvilleHousing

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing



--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject2.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
       WHEN	SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject2.dbo.NashvilleHousing
WHERE SoldAsVacant = 'N' OR SoldAsVacant = 'Y';

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
       WHEN	SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END

--Remove Duplicates

SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) Row_num
	
FROM PortfolioProject2.dbo.NashvilleHousing
)

DELETE
FROM RowNumCTE
WHERE Row_num > 1;