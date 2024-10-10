import { Injectable, NotFoundException } from '@nestjs/common';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Product } from 'src/entities/product.entity';
import { CreateProductDto } from './dtos/create-product.dto';
import { In } from 'typeorm';
import { GetTenentProductDto } from './dtos/get-product.dto';

@Injectable()
export class ProductRepo {
  constructor(@InjectRepository(Product) private repo: Repository<Product>) {}

  private applyFilters(
    queryBuilder: SelectQueryBuilder<Product>,
    params: any,
  ): void {
    if (params.name) {
      queryBuilder.andWhere('name LIKE :name', {
        name: `%${params.name}%`,
      });
    }
  }

  create(payload: CreateProductDto) {
    const product = this.repo.create(payload as any);
    return this.repo.save(product);
  }

  findOne(id: number) {
    if (!id) {
      return null;
    }
    return this.repo.findOneBy({ id: id });
  }

  find(name: string) {
    return this.repo.findBy({ name: name });
  }

  findByIds(ids: number[]) {
    return this.repo.find({ where: { id: In(ids) } });
  }

  async findAll(params: GetTenentProductDto) {
    const queryBuilder = this.repo.createQueryBuilder('product');

    this.applyFilters(queryBuilder, params);

    const page = params.page ?? 1;
    const pageSize = params.pageSize ?? 10;
    const skip = (page - 1) * pageSize;

    const [results, total] = await queryBuilder
      .skip(skip)
      .take(pageSize)
      .getManyAndCount();

    return { results, total };
  }

  async update(id: number, attrs: Partial<Product>) {
    const product = await this.findOne(id);
    if (!product) {
      throw new NotFoundException('Product not found');
    }
    Object.assign(product, attrs);
    return this.repo.save(product);
  }

  remove(id: number) {
    if (!this.repo.findOneBy({ id: id })) {
      throw new NotFoundException('Product not found');
    }
    return this.repo.delete({ id: id });
  }
}
