import {
  IsString,
  IsNumber,
  IsBoolean,
  IsOptional,
  IsArray,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

class ProductPriceDto {
  @IsNumber()
  price: number;

  @IsString()
  displayPrice: string;

  @IsOptional()
  @IsNumber()
  salePrice: number;

  @IsOptional()
  @IsString()
  displaySalePrice: string;
}

export class CreateProductDto {
  @IsString()
  upc: string;

  @IsString()
  name: string;

  @ValidateNested()
  @Type(() => ProductPriceDto)
  price: ProductPriceDto;

  @IsOptional()
  @IsBoolean()
  isOnSale: boolean;

  @IsOptional()
  @IsString()
  fullDescription: string;

  @IsOptional()
  @IsString()
  shortDescription: string;

  @IsOptional()
  @IsString()
  nutritionInformations: string;

  @IsNumber()
  categoryId: number;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  images?: string[];
}
