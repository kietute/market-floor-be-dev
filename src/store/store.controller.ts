import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { CreateStoreDto } from './dtos/create-store.dto';
import { StoreService } from './store.service';
import { StaffGuard } from 'src/common/guards/staff.guard';
import { GetStoreDto } from './dtos/get-store.dto';
import { UpdateStoreDto } from './dtos/update-store.dto';
import { Serialize } from '../common/interceptors/serialize.interceptor';
import { UserDto } from '../auth/dtos/user.dto';
import { StoreDto } from './dtos/store.dto';
import { AdminGuard } from '../common/guards/admin.guard'; // Import the Update DTO

@Controller('/store')
export class StoreController {
  constructor(private readonly storeService: StoreService) {}

  @Post('/')
  @UseGuards(AdminGuard)
  async createStore(@Body() body: CreateStoreDto) {
    const store = await this.storeService.createStore(body);
    return store;
  }

  @Get('/')
  @UseGuards(AdminGuard)
  // @Serialize(StoreDto)
  async getStores(@Query() query: GetStoreDto) {
    const stores = await this.storeService.getStores(query);
    return stores;
  }

  @Get('/:id')
  @UseGuards(AdminGuard)
  async getStoreById(@Param('id') id: number) {
    const store = await this.storeService.getStoreById(id);
    return store;
  }

  @Patch('/:id')
  @UseGuards(AdminGuard)
  async updateStore(@Param('id') id: number, @Body() body: UpdateStoreDto) {
    return await this.storeService.update(id, body);
  }

  @Delete('/:id')
  @UseGuards(AdminGuard)
  async removeStore(@Param('id') id: number) {
    return this.storeService.remove(id);
  }
}
