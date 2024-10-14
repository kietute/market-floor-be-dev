import { Injectable, NotFoundException } from '@nestjs/common';
import { DeleteResult, Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Store } from 'src/entities/store.entity';
import { CreateStoreDto } from './dtos/create-store.dto';
import { GetStoreDto } from './dtos/get-store.dto';

@Injectable()
export class StoreRepo {
  constructor(@InjectRepository(Store) private repo: Repository<Store>) {}

  create(payload: CreateStoreDto) {
    const store = this.repo.create(payload as any);
    return this.repo.save(store);
  }
  
  save(store: Store): Promise<Store> {
    return this.repo.save(store);
  }
  remove(id: number) {
    if (!this.repo.findOneBy({ id: id })) {
      throw new NotFoundException('Store not found');
    }
    return this.repo.delete({ id: id });
  }

  findById(id: number) {
    return this.repo.findOneBy({ id: id });
  }
  async findAll(
    params: GetStoreDto,
  ): Promise<{ data: Store[]; total: number }> {
    const queryBuilder = this.repo.createQueryBuilder('store');

    // filter if have name
    if (params.name) {
      queryBuilder.andWhere('store.name LIKE :name', {
        name: `%${params.name}%`,
      });
    }

    if (params.currentLng && params.currentLat) {
      const currentLng = params.currentLng;
      const currentLat = params.currentLat;
      // caculate distance
      queryBuilder.addSelect(
        `
      (3959 * acos(cos(radians(${currentLat})) 
      * cos(radians(store.lat)) 
      * cos(radians(store.lng) - radians(${currentLng})) 
      + sin(radians(${currentLat})) 
      * sin(radians(store.lat))))`,
        'distance',
      );

      queryBuilder.orderBy('distance', 'ASC'); // sort ascending
    }

    // pagination
    const page = params.page ?? 1;
    const pageSize = params.pageSize ?? 10;
    const skip = (page - 1) * pageSize;

    const [data, total] = await queryBuilder
      .skip(skip)
      .take(pageSize)
      .getManyAndCount();

    return { data, total };
  }
}
